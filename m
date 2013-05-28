From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 12/19] cifs: track the flavor of the NEGOTIATE reponse
Date: Tue, 28 May 2013 09:46:43 +0400
Message-ID: <CAKywueTSo=+Wis6pfxkz-dM036Rxbs_z8H4nDDDZ5tLRyBZUMA@mail.gmail.com>
References: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
	<1369321563-16893-13-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369321563-16893-13-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/5/23 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Track what sort of NEGOTIATE response we get from the server, as that
> will govern what sort of authentication types this socket will support.
>
> There are three possibilities:
>
> LANMAN: server sent legacy LANMAN-type response
>
> UNENCAP: server sent a newer-style response, but extended security bit
> wasn't set. This socket will only support unencapsulated auth types.
>
> EXTENDED: server sent a newer-style response with the extended security
> bit set. This is necessary to support krb5 and ntlmssp auth types.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |  4 ++++
>  fs/cifs/cifssmb.c  | 15 ++++++++++-----
>  fs/cifs/smb2pdu.c  |  2 ++
>  3 files changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index a858037..c2ef6c1 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -540,6 +540,10 @@ struct TCP_Server_Info {
>         struct session_key session_key;
>         unsigned long lstrp; /* when we got last response from this server */
>         struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
> +#define        CIFS_NEGFLAVOR_LANMAN   0       /* wct == 13, LANMAN */
> +#define        CIFS_NEGFLAVOR_UNENCAP  1       /* wct == 17, but no ext_sec */
> +#define        CIFS_NEGFLAVOR_EXTENDED 2       /* wct == 17, ext_sec bit set */
> +       char    negflavor;      /* NEGOTIATE response flavor */
>         /* extended security flavors that server supports */
>         bool    sec_ntlmssp;            /* supports NTLMSSP */
>         bool    sec_kerberosu2u;        /* supports U2U Kerberos */
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index e7184b9..b43948a 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -616,6 +616,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
>                 goto neg_err_exit;
>         } else if (pSMBr->hdr.WordCount == 13) {
>                 rc = decode_lanman_negprot_rsp(server, pSMBr, secFlags);
> +               server->negflavor = CIFS_NEGFLAVOR_LANMAN;
>                 goto neg_err_exit;
>         } else if (pSMBr->hdr.WordCount != 17) {
>                 /* unknown wct */
> @@ -666,17 +667,21 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
>         server->timeAdj = (int)(__s16)le16_to_cpu(pSMBr->ServerTimeZone);
>         server->timeAdj *= 60;
>
> -       if (pSMBr->EncryptionKeyLength == CIFS_CRYPTO_KEY_SIZE)
> +       if (pSMBr->EncryptionKeyLength == CIFS_CRYPTO_KEY_SIZE) {
> +               server->negflavor = CIFS_NEGFLAVOR_UNENCAP;
>                 memcpy(ses->server->cryptkey, pSMBr->u.EncryptionKey,
>                        CIFS_CRYPTO_KEY_SIZE);
> -       else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC ||
> +       } else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC ||
>                         server->capabilities & CAP_EXTENDED_SECURITY) &&
> -                               (pSMBr->EncryptionKeyLength == 0))
> +                               (pSMBr->EncryptionKeyLength == 0)) {
> +               server->negflavor = CIFS_NEGFLAVOR_EXTENDED;
>                 rc = decode_ext_sec_blob(server, pSMBr);
> -       else if (server->sec_mode & SECMODE_PW_ENCRYPT)
> +       } else if (server->sec_mode & SECMODE_PW_ENCRYPT) {
>                 rc = -EIO; /* no crypt key only if plain text pwd */
> -       else
> +       } else {
> +               server->negflavor = CIFS_NEGFLAVOR_UNENCAP;
>                 server->capabilities &= ~CAP_EXTENDED_SECURITY;
> +       }
>
>         if (!rc)
>                 rc = cifs_enable_signing(server, secFlags);
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index ebb97b4..1609699 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -405,6 +405,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>         }
>         server->dialect = le16_to_cpu(rsp->DialectRevision);
>
> +       /* SMB2 only has an extended negflavor */
> +       server->negflavor = CIFS_NEGFLAVOR_EXTENDED;
>         server->maxBuf = le32_to_cpu(rsp->MaxTransactSize);
>         server->max_read = le32_to_cpu(rsp->MaxReadSize);
>         server->max_write = le32_to_cpu(rsp->MaxWriteSize);
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--
Best regards,
Pavel Shilovsky.
