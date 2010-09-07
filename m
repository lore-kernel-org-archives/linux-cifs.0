From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] remove unused function CalcNTLMv2_partial_mac_key
Date: Tue, 7 Sep 2010 07:12:48 -0500
Message-ID: <AANLkTi=bGyHnMVADH=jdF3=UcTT8k1tpuKkQ4HBQWG9y@mail.gmail.com>
References: <1283830340-24991-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100907071758.67e8d753@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100907071758.67e8d753-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This gets removed in one of the patches.

On Tue, Sep 7, 2010 at 6:17 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, =A06 Sep 2010 22:32:20 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 57 ----------------------------------=
---------------
>> =A01 files changed, 0 insertions(+), 57 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 86e33cc..4f85651 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -224,63 +224,6 @@ int cifs_calculate_mac_key(struct session_key *=
key, const char *rn,
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> -int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *ses,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struc=
t nls_table *nls_info)
>> -{
>> - =A0 =A0 char temp_hash[16];
>> - =A0 =A0 struct HMACMD5Context ctx;
>> - =A0 =A0 char *ucase_buf;
>> - =A0 =A0 __le16 *unicode_buf;
>> - =A0 =A0 unsigned int i, user_name_len, dom_name_len;
>> -
>> - =A0 =A0 if (ses =3D=3D NULL)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> -
>> - =A0 =A0 E_md4hash(ses->password, temp_hash);
>> -
>> - =A0 =A0 hmac_md5_init_limK_to_64(temp_hash, 16, &ctx);
>> - =A0 =A0 user_name_len =3D strlen(ses->userName);
>> - =A0 =A0 if (user_name_len > MAX_USERNAME_SIZE)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> - =A0 =A0 if (ses->domainName =3D=3D NULL)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL; /* BB should we use CIFS_L=
INUX_DOM */
>> - =A0 =A0 dom_name_len =3D strlen(ses->domainName);
>> - =A0 =A0 if (dom_name_len > MAX_USERNAME_SIZE)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> -
>> - =A0 =A0 ucase_buf =3D kmalloc((MAX_USERNAME_SIZE+1), GFP_KERNEL);
>> - =A0 =A0 if (ucase_buf =3D=3D NULL)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> - =A0 =A0 unicode_buf =3D kmalloc((MAX_USERNAME_SIZE+1)*4, GFP_KERNE=
L);
>> - =A0 =A0 if (unicode_buf =3D=3D NULL) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 kfree(ucase_buf);
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 for (i =3D 0; i < user_name_len; i++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 ucase_buf[i] =3D nls_info->charset2upper[(=
int)ses->userName[i]];
>> - =A0 =A0 ucase_buf[i] =3D 0;
>> - =A0 =A0 user_name_len =3D cifs_strtoUCS(unicode_buf, ucase_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 MAX_USERNAME_SIZE*2, nls_info);
>> - =A0 =A0 unicode_buf[user_name_len] =3D 0;
>> - =A0 =A0 user_name_len++;
>> -
>> - =A0 =A0 for (i =3D 0; i < dom_name_len; i++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 ucase_buf[i] =3D nls_info->charset2upper[(=
int)ses->domainName[i]];
>> - =A0 =A0 ucase_buf[i] =3D 0;
>> - =A0 =A0 dom_name_len =3D cifs_strtoUCS(unicode_buf+user_name_len, =
ucase_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
MAX_USERNAME_SIZE*2, nls_info);
>> -
>> - =A0 =A0 unicode_buf[user_name_len + dom_name_len] =3D 0;
>> - =A0 =A0 hmac_md5_update((const unsigned char *) unicode_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 (user_name_len+dom_name_len)*2, &ctx);
>> -
>> - =A0 =A0 hmac_md5_final(ses->server->ntlmv2_hash, &ctx);
>> - =A0 =A0 kfree(ucase_buf);
>> - =A0 =A0 kfree(unicode_buf);
>> - =A0 =A0 return 0;
>> -}
>> -
>> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> =A0void calc_lanman_hash(const char *password, const char *cryptkey,=
 bool encrypt,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *lnm_session_key)
>
> What about the declaration in cifsproto.h?
>
> Other than that...strong ACK here. We should get rid of as much unuse=
d
> bloat as possible.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
