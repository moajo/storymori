# storymori

# serverの挙動
port 3001にデフォルトで立つ。環境変数で指定できると良い。

エンドポイントは以下の４つ
- GET /api/stories
- POST /api/stories
- GET /api/stories/:storyId/pages/:pageId
- POST /api/stories/:storyId/pages/:parentId/next

## GET /api/stories
```
SELECT s.id, s.title, p.id AS parentId 
FROM stories s
INNER JOIN pages p ON s.id = p.story_id
WHERE p.parent_id is null;
```
の結果をjsonで返す。

## POST /api/stories
ポストされる値に以下のバリデーションで400を返す。
```
check('title')
    .exists()
    .not()
    .isEmpty(),
  check('text')
    .exists()
    .not()
    .isEmpty()
```
ストーリーを作成する以下のクエリを発行
```js
`insert into stories (title, summary) values (${title},${text.slice(0, 10)})`
```
作成したストーリに対してページ作成する以下のクエリを発行
``` 
 const insertPageQuery =
      'insert into pages (name, text, story_id) values (?, ?, ?)';
    const [pageResults] = await connection.query(insertPageQuery, [
      title,
      text,
      storyId
    ]);
```
返るjsonは
```
res.json({ storyId, pageId });
```

## GET /api/stories/:storyId/pages/:pageId
ポストされる値に以下のバリデーションで404を返す。
```
  check('storyId')
    .isNumeric({no_symbols: true}),
  check('pageId')
    .isNumeric({no_symbols: true})
```
ページを検索するする以下のクエリを発行
```js
  const query =
      'select id, name, text from pages where id = ? and story_id = ?';
    const [results] = await connection.query(query, [pageId, storyId]);
```
０件だと404。
同じストーリーに対するページを全て検索
``` 
 const childrenQuery = 'select id, name from pages where parent_id = ?';
```
これを`children`フォールドに入れてjsonを返す

## POST /api/stories/:storyId/pages/:parentId/next
バリデーションで400
```
check('name')
    .not()
    .isEmpty(),
  check('text')
    .not()
    .isEmpty(),
  check('storyId')
    .isNumeric({no_symbols: true}),
  check('parentId')
    .isNumeric({no_symbols: true})
```

以下のクエリで親ページの存在確認
```
  const query = 'select id from pages where id = ? and story_id = ?';
    const [pages] = await connection.query(query, [parentId, storyId]);
```
ページ作成
```
const insertPageQuery =
      'insert into pages (name, text, story_id, parent_id) values (?,?,?,?)';
    const [pageResults] = await connection.query(insertPageQuery, [
      name,
      text,
      storyId,
      parentId
    ]);
```
idをjsonで返す。

## その他
その他のエンドポイントへのアクセスは404



