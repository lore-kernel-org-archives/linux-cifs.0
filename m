From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: Error STATUS_INVALID_OWNER should map to EACCES
Date: Tue,  8 Dec 2015 17:29:37 +0530
Message-ID: <1449575977-9783-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Error STATUS_INVALID_OWNER maps to -EIO. This was encountered when
a non priviledged user attempts to change ownership on a file to anothe=
r
user on a share mounted with the cifsacl mount option.

 # chown wintest1 a
chown: changing ownership of =E2=80=98a=E2=80=99: Input/output error

The error returned is confusing for users who do not expect this error.
The proposal is to return -EACCES instead when a STATUS_INVALID_OWNER i=
s
returned.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/netmisc.c      | 2 +-
 fs/cifs/smb2maperror.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index abae6dd..301d3d4 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -324,7 +324,7 @@ static const struct {
 	ERRDOS, ERRunsup, NT_STATUS_CTL_FILE_NOT_SUPPORTED}, {
 	ERRHRD, ERRgeneral, NT_STATUS_UNKNOWN_REVISION}, {
 	ERRHRD, ERRgeneral, NT_STATUS_REVISION_MISMATCH}, {
-	ERRHRD, ERRgeneral, NT_STATUS_INVALID_OWNER}, {
+	ERRDOS, ERRnoaccess, NT_STATUS_INVALID_OWNER}, {
 	ERRHRD, ERRgeneral, NT_STATUS_INVALID_PRIMARY_GROUP}, {
 	ERRHRD, ERRgeneral, NT_STATUS_NO_IMPERSONATION_TOKEN}, {
 	ERRHRD, ERRgeneral, NT_STATUS_CANT_DISABLE_MANDATORY}, {
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 8257a5a..fd88cfa 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -384,7 +384,7 @@ static const struct status_to_posix_error smb2_erro=
r_map_table[] =3D {
 	"STATUS_CTL_FILE_NOT_SUPPORTED"},
 	{STATUS_UNKNOWN_REVISION, -EIO, "STATUS_UNKNOWN_REVISION"},
 	{STATUS_REVISION_MISMATCH, -EIO, "STATUS_REVISION_MISMATCH"},
-	{STATUS_INVALID_OWNER, -EIO, "STATUS_INVALID_OWNER"},
+	{STATUS_INVALID_OWNER, -EACCES, "STATUS_INVALID_OWNER"},
 	{STATUS_INVALID_PRIMARY_GROUP, -EIO, "STATUS_INVALID_PRIMARY_GROUP"},
 	{STATUS_NO_IMPERSONATION_TOKEN, -EIO, "STATUS_NO_IMPERSONATION_TOKEN"=
},
 	{STATUS_CANT_DISABLE_MANDATORY, -EIO, "STATUS_CANT_DISABLE_MANDATORY"=
},
--=20
2.4.3
