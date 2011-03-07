From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: add missing unicode handling routines needed for smb2
Date: Mon, 7 Mar 2011 09:07:52 -0600
Message-ID: <AANLkTinnHSpJMMvTVU77fgcgZWum6Ovb5SfOSxPbSfSG@mail.gmail.com>
References: <AANLkTinVkEHg-DOp6+0Jq+_vteYaix+nqt=QNFJ7nSML@mail.gmail.com>
	<20110307094123.065e59c6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110307094123.065e59c6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Mar 7, 2011 at 8:41 AM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> w=
rote:
> On Sun, 6 Mar 2011 22:17:32 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> This patch appears to be malformed...

Cut-paste or mailer error.

commit 11471483dbfd2f4235346acf9e181a549b3979a1
Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date:   Mon Mar 7 04:15:05 2011 +0000

    [CIFS] Add missing unicode handling routines needed by smb2

    Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index fc0fd4f..9dd2682 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -333,3 +333,64 @@ ctoUCS_out:
 	return i;
 }

+#ifdef CONFIG_CIFS_SMB2
+/*
+ * smb2_local_to_ucs2_bytes - how long will a string be after conversi=
on?
+ * @from - pointer to input string
+ * @maxbytes - don't go past this many bytes of input string
+ * @codepage - source codepage
+ *
+ * Walk a string and return the number of bytes that the string will
+ * be after being converted to the given charset, not including any nu=
ll
+ * termination required. Don't walk past maxbytes in the source buffer=
=2E
+ */
+
+int
+smb2_local_to_ucs2_bytes(const char *from, int len,
+			  const struct nls_table *codepage)
+{
+	int charlen;
+	int i;
+	wchar_t wchar_to;
+
+	if (from =3D=3D NULL)
+		return 0;
+	for (i =3D 0; len && *from; i++, from +=3D charlen, len -=3D charlen)=
 {
+		charlen =3D codepage->char2uni(from, len, &wchar_to);
+		/* Failed conversion defaults to a question mark */
+		if (charlen < 1)
+			charlen =3D 1;
+	}
+	return 2 * i; /* UCS characters are two bytes */
+}
+
+/*
+ * smb2_strndup_to_ucs - copy a string to wire format from the local c=
odepage
+ * @src - source string
+ * @maxlen - don't walk past this many bytes in the source string
+ * @ucslen - the length of the allocated string in bytes (including nu=
ll)
+ * @codepage - source codepage
+ *
+ * Take a string convert it from the local codepage to UCS2 and
+ * put it in a new buffer. Returns a pointer to the new string or NULL=
 on
+ * error.
+ */
+__le16 *
+smb2_strndup_to_ucs(const char *src, const int maxlen, int *ucs_len,
+	     const struct nls_table *codepage)
+{
+	int len;
+	__le16 *dst;
+
+	len =3D smb2_local_to_ucs2_bytes(src, maxlen, codepage);
+	len +=3D 2; /* NULL */
+	dst =3D kmalloc(len, GFP_KERNEL);
+	if (!dst) {
+		*ucs_len =3D 0;
+		return NULL;
+	}
+	cifs_strtoUCS(dst, src, maxlen, codepage);
+	*ucs_len =3D len;
+	return dst;
+}
+#endif /* CONFIG_CIFS_SMB2 */
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index 7fe6b52..a56dfbc 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -377,4 +377,11 @@ UniStrlwr(register wchar_t *upin)

 #endif

+#ifdef CONFIG_CIFS_SMB2
+extern int smb2_local_to_ucs2_bytes(const char *from, int len,
+				    const struct nls_table *codepage);
+extern __le16 *smb2_strndup_to_ucs(const char *src, const int maxlen,
+				   int *ucs_len, const struct nls_table *cp);
+#endif /* CONFIG_CIFS_SMB2 */
+
 #endif /* _CIFS_UNICODE_H */


>> =A0go past this many bytes of input string
>> + * @codepage - source codepage
>> + *
>> + * Walk a string and return the number of bytes that the string wil=
l
>> + * be after being converted to the given charset, not including any=
 null
>> + * termination required. Don't walk past maxbytes in the source buf=
fer.
>> + */
>> +
>> +int
>> +smb2_local_to_ucs2_bytes(const char *from, int len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table=
 *codepage)
>> +{
>> + =A0 =A0 int charlen;
>> + =A0 =A0 int i;
>> + =A0 =A0 wchar_t wchar_to;
>> +
>> + =A0 =A0 if (from =3D=3D NULL)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 for (i =3D 0; len && *from; i++, from +=3D charlen, len -=3D=
 charlen) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D codepage->char2uni(from, len, =
&wchar_to);
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* Failed conversion defaults to a questio=
n mark */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (charlen < 1)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D 1;
>> + =A0 =A0 }
>> + =A0 =A0 return 2 * i; /* UCS characters are two bytes */
>> +}
>> +
>> +/*
>> + * smb2_strndup_to_ucs - copy a string to wire format from the loca=
l codepage
>> + * @src - source string
>> + * @maxlen - don't walk past this many bytes in the source string
>> + * @ucslen - the length of the allocated string in bytes (including=
 null)
>> + * @codepage - source codepage
>> + *
>> + * Take a string convert it from the local codepage to UCS2 and
>> + * put it in a new buffer. Returns a pointer to the new string or N=
ULL on
>> + * error.
>> + */
>> +__le16 *
>> +smb2_strndup_to_ucs(const char *src, const int maxlen, int *ucs_len=
,
>> + =A0 =A0 =A0 =A0 =A0const struct nls_table *codepage)
>> +{
>> + =A0 =A0 int len;
>> + =A0 =A0 __le16 *dst;
>> +
>> + =A0 =A0 len =3D smb2_local_to_ucs2_bytes(src, maxlen, codepage);
>> + =A0 =A0 len +=3D 2; /* NULL */
>> + =A0 =A0 dst =3D kmalloc(len, GFP_KERNEL);
>> + =A0 =A0 if (!dst) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 *ucs_len =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> + =A0 =A0 }
>> + =A0 =A0 cifs_strtoUCS(dst, src, maxlen, codepage);
>> + =A0 =A0 *ucs_len =3D len;
>> + =A0 =A0 return dst;
>> +}
>> +#endif /* CONFIG_CIFS_SMB2 */
>> diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
>> index 7fe6b52..a56dfbc 100644
>> --- a/fs/cifs/cifs_unicode.h
>> +++ b/fs/cifs/cifs_unicode.h
>> @@ -377,4 +377,11 @@ UniStrlwr(register wchar_t *upin)
>>
>> =A0#endif
>>
>> +#ifdef CONFIG_CIFS_SMB2
>> +extern int smb2_local_to_ucs2_bytes(const char *from, int len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 co=
nst struct nls_table *codepage);
>> +extern __le16 *smb2_strndup_to_ucs(const char *src, const int maxle=
n,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int=
 *ucs_len, const struct nls_table *cp);
>> +#endif /* CONFIG_CIFS_SMB2 */
>> +
>> =A0#endif /* _CIFS_UNICODE_H */
>>
>> --
>> Thanks,
>>
>> Steve
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
> --
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
>



--=20
Thanks,

Steve
