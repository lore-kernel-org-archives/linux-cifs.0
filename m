From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Handle big endianness in NTLM (ntlmv2) authentication
Date: Tue, 25 Jun 2013 13:37:22 -0500
Message-ID: <CAH2r5ms+51yZtiidxAS1B9NhXqCQMPQv1hnidSdGaJNA3VE23g@mail.gmail.com>
References: <1372175077-12846-1-git-send-email-shirishpargaonkar@gmail.com>
	<20130625134929.29f7a1c3@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130625134929.29f7a1c3-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

To remove endian warning on build, I added this (might be easier to
merge the patches)

diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index bec1137..fe8d627 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -327,10 +327,10 @@ UniToupper(register wchar_t uc)
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
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 5c89f37..3308759 100644
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

@@ -447,7 +447,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses,
char *ntlmv2_hash,
 	}

 	if (len) {
-		len = cifs_strtoUTF16((__le16 *)user, ses->user_name, len, nls_cp);
+		len = cifs_strtoUTF16(user, ses->user_name, len, nls_cp);
 		UniStrupr(user);
 	} else {
 		memset(user, '\0', 2);
On Tue, Jun 25, 2013 at 12:49 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 25 Jun 2013 10:44:37 -0500b
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> This is RH bug 970891
>> Uppercasing of username during calculation of ntlmv2 hash fails
>> because UniStrupr function does not handle big endian wchars.
>>
>> Also fix a comment in the same code to reflect its correct usage.
>>
>>
>> Reported-by: steve <sanpatr1-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> ---
>>  fs/cifs/cifs_unicode.h |    2 +-
>>  fs/cifs/cifsencrypt.c  |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
>> index 4fb0974..bec1137 100644
>> --- a/fs/cifs/cifs_unicode.h
>> +++ b/fs/cifs/cifs_unicode.h
>> @@ -334,7 +334,7 @@ UniStrupr(register wchar_t *upin)
>>
>>       up = upin;
>>       while (*up) {           /* For all characters */
>> -             *up = UniToupper(*up);
>> +             *up = cpu_to_le16(UniToupper(le16_to_cpu(*up)));
>>               up++;
>>       }
>>       return upin;            /* Return input pointer */
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 71436d1..8b34a73 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -439,7 +439,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
>>               return rc;
>>       }
>>
>> -     /* convert ses->user_name to unicode and uppercase */
>> +     /* convert ses->user_name to unicode */
>>       len = ses->user_name ? strlen(ses->user_name) : 0;
>>       user = kmalloc(2 + (len * 2), GFP_KERNEL);
>>       if (user == NULL) {
>
> Looks correct. Nice work tracking that down!
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



-- 
Thanks,

Steve
