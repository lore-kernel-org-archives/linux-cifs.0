From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
Subject: Re: [PATCH] cifs: Fix slab-out-of-bounds in send_set_info() on SMB2 ACE setting
Date: Thu, 05 Jul 2018 16:35:00 +0200
Message-ID: <87d0w17nu3.fsf@suse.com>
References: <af471807b329692a387ff26e62e1bbca01e1684f.1530783326.git.sbrivio@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Jianhong Yin <jiyin@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        stable@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>
To: Stefano Brivio <sbrivio@redhat.com>,
        Steve French <sfrench@samba.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <af471807b329692a387ff26e62e1bbca01e1684f.1530783326.git.sbrivio@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> writes:
>  	/* BB eventually switch this to SMB2 specific small buf size */
> -	*request_buf = cifs_small_buf_get();
> +	if (smb2_command == SMB2_SET_INFO)
> +		*request_buf = cifs_buf_get();
> +	else
> +		*request_buf = cifs_small_buf_get();
>  	if (*request_buf == NULL) {
>  		/* BB should we add a retry in here if not a writepage? */
>  		return -ENOMEM;
> @@ -3720,7 +3723,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
>  
>  	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags,
>  			    &rsp_iov);
> -	cifs_small_buf_release(req);
> +	cifs_buf_release(req);
>  	rsp = (struct smb2_set_info_rsp *)rsp_iov.iov_base;

Small and large bufs use different mempools, shouldn't the release func
match the get func?

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
