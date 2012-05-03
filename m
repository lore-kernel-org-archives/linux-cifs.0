From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] fs/cifs: fix parsing of dfs referrals
Date: Fri,  4 May 2012 00:19:28 +0200
Message-ID: <1336083568-28740-1-git-send-email-metze@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org,
	metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The problem was that the first referral was parsed more than once
and so the caller tried the same referrals multiple times.

The problem was introduced partly by commit
066ce6899484d9026acd6ba3a8dbbedb33d7ae1b,
where 'ref +=3D le16_to_cpu(ref->Size);' got lost,
but that was also wrong...

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Tested-by: Bj=C3=B6rn Jacke <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
---
 fs/cifs/cifssmb.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index f52c5ab..da2f544 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4844,8 +4844,12 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_R=
SP *pSMBr,
 		max_len =3D data_end - temp;
 		node->node_name =3D cifs_strndup_from_utf16(temp, max_len,
 						is_unicode, nls_codepage);
-		if (!node->node_name)
+		if (!node->node_name) {
 			rc =3D -ENOMEM;
+			goto parse_DFS_referrals_exit;
+		}
+
+		ref++;
 	}
=20
 parse_DFS_referrals_exit:
--=20
1.7.4.1
