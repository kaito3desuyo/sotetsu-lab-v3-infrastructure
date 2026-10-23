# ロードマップ（infrastructure）

2026-10-23 に棚卸しした、次のマイルストーンのうち infrastructure が関わる分。設計の判断は着手時に `docs/adr/` に書く。

## 全体の順番

M0 後始末 → M1 登録制 ② → M2 SSR → M3 臨時列車 → M4 API の外部公開。M5 過去の目撃データの補完（段1：解析）は M1 と並行。M18 投稿の見回りは M1 の公開と同じ頃に、M19 障害の見張りはいつでも（早いほどよい）、M20〜M22 はいつでも差し込める。M26 免責事項・プライバシーポリシーは M1 の告知日より前に、M23 開発用 DB の分離は M3・M17・M20 より前に、M24・M25 はいつでも。性能と費用削減も並行で進めるが、手をつける前に計測する。他のリポジトリの分は、それぞれの `docs/roadmap.md` にある。

## infrastructure の分

| # | 名前 | infrastructure でやること | 着手前に決める・確かめること |
|---|---|---|---|
| M2 | SSR | 画面の配信（S3・CloudFront・OAC・GitHub Actions の secret）を Terraform から外す。配信は client の `serverless.ts`（osls）に移る（client ADR-0012・2026-10-24 ユーザー判断）。`terraform state rm module.web` の後に `modules/web`・`environments/default` の `module "web"`・`data "aws_acm_certificate" "virginia"`・`provider "aws"` の `virginia` を消す | 切り替え（client の計画 `docs/superpowers/plans/2026-10-24-web-delivery-to-osls.md` の Task 6）が済んでから。master のユーザーの未コミットの変更（database 周り）と混ぜない。network・database・api のモジュールは残す |
| M19 | 障害の見張り | API・socket・backend の Lambda のエラー・5xx・タイムアウト（api は 3 秒）に CloudWatch のアラームを掛け、メールか Discord に知らせる | 知らせる先。費用削減の作戦書とぶつからない程度の数にする |
| M24 | バックアップから戻す練習 | Supabase のバックアップから別の場所へ戻す手順を一度試して書き残す | M6・M17 のように本番へ大量に書く前に。Pro の毎日のバックアップで足りるか、PITR が要るか |
| 並行 | 費用削減 | 2026-07 の作戦書（ワークスペースの `.context/infra-cost-strategy-2026-07.md`）の Tier を、リスクの低い順に進める | aws-vault の MFA が要る。v2 の Aurora バックアップ（`sotetsu-lab-v2-backup-cluster` とそのスナップショット）は消さない。中身はリニューアル前のサイト（v2）のデータで、相鉄館のデータも取り込まれていたはず。2014〜2018 年は v2 にしか無い分があると見ているが、Supabase にも同じ期間が毎日分ある（2026-10-23 実測）ので、作戦書のとおり論理ダンプを取って行数を照合してから扱いを決める |
