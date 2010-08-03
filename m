From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [linux-cifs-client][PATCH] Enable signing for ntlmv2 within
	NTLMSSP using kernel crypto APIs
Date: Mon, 2 Aug 2010 23:46:07 -0500
Message-ID: <AANLkTimtgejfxW8P_GvGqD3muu2Wh6BfC-xPTpNtJb9+@mail.gmail.com>
References: <1280604866-9505-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100802065508.GA8431@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100802065508.GA8431-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Aug 2, 2010 at 1:55 AM, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org=
> wrote:
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>>
>> static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 const struct mac_key *key, char *signature)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP_Server_Info=
 *server, char *signature)
>> {
>> - =A0 =A0 =A0 struct =A0MD5Context context;
>> + =A0 =A0 =A0 int rc =3D 0;
>> + =A0 =A0 =A0 struct scatterlist sgin[2];
>> + =A0 =A0 =A0 struct hash_desc desc;
>>
>> - =A0 =A0 =A0 if ((cifs_pdu =3D=3D NULL) || (signature =3D=3D NULL) =
|| (key =3D=3D NULL))
>> + =A0 =A0 =A0 if (cifs_pdu =3D=3D NULL || server =3D=3D NULL || sign=
ature =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>>
>> - =A0 =A0 =A0 cifs_MD5_init(&context);
>> - =A0 =A0 =A0 cifs_MD5_update(&context, (char *)&key->data, key->len=
);
>> - =A0 =A0 =A0 cifs_MD5_update(&context, cifs_pdu->Protocol, cifs_pdu=
->smb_buf_length);
>> + =A0 =A0 =A0 desc.tfm =3D server->ntlmssp.tfm_md5;
>> +
>> + =A0 =A0 =A0 rc =3D crypto_hash_init(&desc);
>
> We're phasing out the crypto_hash_* interface. =A0Please use the
> equivalent crypto_shash_* interface (or if you require access
> to asynchronous hardware, the crypto_ahash_* interface).
>
> Thanks,
> --
> Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>

Herbert,

I have compile issues with crypto_shash interfaces, no such issues
with crypto_hash_ APIs,
everything works fine.

When I have code like this, I have errors and warning and when I cast
them as (char *),  module
oopses.

struct session_key {
        unsigned int len;
        union {
                char ntlm[CIFS_SESS_KEY_SIZE + 16];
                char krb5[CIFS_SESS_KEY_SIZE + 16]; /* BB: length corre=
ct? */
                struct {
                        char key[16];
                        struct ntlmv2_resp resp;
                } ntlmv2;
        } data;
};
        if (server->secType =3D=3D RawNTLMSSP)
                crypto_shash_update(&desc, server->session_key.data.ntl=
mv2.key,
                                CIFS_NTLMV2_SESSKEY_SIZE);
        else
                crypto_shash_update(&desc, server->session_key.data,
          <----
                                server->session_key.len);


And
        len =3D cifs_strtoUCS((__le16 *)user, ses->userName, len, nls_c=
p);
        UniStrupr(user);

        crypto_shash_update(&desc, user, 2 * len);
                         <----

No such issues and oops with crypto_hash_APIs.
