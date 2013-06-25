From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cifs: Handle big endianness in NTLM (ntlmv2) authentication [V2]
Date: Tue, 25 Jun 2013 14:06:18 -0500
Message-ID: <CAH2r5mt4fJHBzXT5Su6Wy8EADZOZrvRUmPXf9gXA-xYYVd0Qjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>From 157074c6c81e0fa3e7976d2bf39dd865edcce38e Mon Sep 17 00:00:00 2001
From: Steve French <smfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date: Tue, 25 Jun 2013 14:03:16 -0500
Subject: [PATCH] [CIFS] Handle big endianness in NTLM (ntlmv2) authentication

This is RH bug 970891
Uppercasing of username during calculation of ntlmv2 hash fails
because UniStrupr function does not handle big endian wchars.

Also fix a comment in the same code to reflect its correct usage.

[To make it easier for stable (rather than require 2nd patch) fixed
this patch of Shirish's to remove endian warning generated
by sparse -- steve f.]

Reported-by: steve <sanpatr1-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifs_unicode.h | 8 ++++----
 fs/cifs/cifsencrypt.c  | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index 4fb0974..fe8d627 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -327,14 +327,14 @@ UniToupper(register wchar_t uc)
 /*
  * UniStrupr:  Upper case a unicode string
  */
-static inline wchar_t *
-UniStrupr(register wchar_t *upin)
+static inline __le16 *
+UniStrupr(register __le16 *upin)
 {
-	register wchar_t *up;
+	register __le16 *up;

 	up = upin;
 	while (*up) {		/* For all characters */
-		*up = UniToupper(*up);
+		*up = cpu_to_le16(UniToupper(le16_to_cpu(*up)));
 		up++;
 	}
 	return upin;		/* Return input pointer */
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 30bea6b..3308759 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -413,7 +413,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses,
char *ntlmv2_hash,
 	int rc = 0;
 	int len;
 	char nt_hash[CIFS_NTHASH_SIZE];
-	wchar_t *user;
+	__le16 *user;
 	wchar_t *domain;
 	wchar_t *server;

@@ -438,7 +438,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses,
char *ntlmv2_hash,
 		return rc;
 	}

-	/* convert ses->user_name to unicode and uppercase */
+	/* convert ses->user_name to unicode */
 	len = ses->user_name ? strlen(ses->user_name) : 0;
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
 	if (user == NULL) {
@@ -447,7 +447,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses,
char *ntlmv2_hash,
 	}

 	if (len) {
-		len = cifs_strtoUTF16((__le16 *)user, ses->user_name, len, nls_cp);
+		len = cifs_strtoUTF16(user, ses->user_name, len, nls_cp);
 		UniStrupr(user);
 	} else {
 		memset(user, '\0', 2);
-- 
1.8.1.2

On Tue, Jun 25, 2013 at 10:44 AM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> This is RH bug 970891
> Uppercasing of username during calculation of ntlmv2 hash fails
> because UniStrupr function does not handle big endian wchars.
>
> Also fix a comment in the same code to reflect its correct usage.
>
>
> Reported-by: steve <sanpatr1-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  fs/cifs/cifs_unicode.h |    2 +-
>  fs/cifs/cifsencrypt.c  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
> index 4fb0974..bec1137 100644
> --- a/fs/cifs/cifs_unicode.h
> +++ b/fs/cifs/cifs_unicode.h
> @@ -334,7 +334,7 @@ UniStrupr(register wchar_t *upin)
>
>         up = upin;
>         while (*up) {           /* For all characters */
> -               *up = UniToupper(*up);
> +               *up = cpu_to_le16(UniToupper(le16_to_cpu(*up)));
>                 up++;
>         }
>         return upin;            /* Return input pointer */
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 71436d1..8b34a73 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -439,7 +439,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
>                 return rc;
>         }
>
> -       /* convert ses->user_name to unicode and uppercase */
> +       /* convert ses->user_name to unicode */
>         len = ses->user_name ? strlen(ses->user_name) : 0;
>         user = kmalloc(2 + (len * 2), GFP_KERNEL);
>         if (user == NULL) {
> --
> 1.6.0.2
>



-- 
Thanks,

Steve
