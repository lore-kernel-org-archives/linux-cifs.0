Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50599C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Oct 2021 03:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A4BD611C1
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Oct 2021 03:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243629AbhJPDlg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Oct 2021 23:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233898AbhJPDlf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 15 Oct 2021 23:41:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0865601FC
        for <linux-cifs@vger.kernel.org>; Sat, 16 Oct 2021 03:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634355568;
        bh=HP7ZPW8eZGYglifdfMlU5gMR+jnyNvtpqvPh+RD6hYg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=jPr94++Z8jB66NCa+dc7j2PEDXTO4PdZgbxKl8A2QSbr3yuqOdB46FM7ZUkp7QHdq
         /YM2IWF1UQmgNons/YYGcmBpGjpeFpE/eCv/bvB4DfqoljNwKMLxXULFoTEgibaoS8
         vy7gtAhHDnxO11L8Wp17duvL05kc9Uv1L49vAxnDg35b1DR0FIl9IZUf4MXwvc7pMa
         zZvSXA1DXQVCtbOw/4uQXXlRvZs6w2sAj7fMfmrmdik2kkDd1OiJENaqoHX7ddB2AZ
         vfkcrqld2A2prijbluQnGby+OhbRr9SAGr+djEtjPrFQLEjyaaxjKgG8yMw79ovev9
         uRvl8S66Y1xGg==
Received: by mail-ot1-f52.google.com with SMTP id 62-20020a9d0a44000000b00552a6f8b804so93831otg.13
        for <linux-cifs@vger.kernel.org>; Fri, 15 Oct 2021 20:39:28 -0700 (PDT)
X-Gm-Message-State: AOAM531PG+n6/QZCD0daI2/KI5nWhhveU4+F9r/C5b0NYMIY7Xduyv0G
        UVSaWqcaSoxpqLuDtbPiAva2Gcr8/1uPmTWfZdw=
X-Google-Smtp-Source: ABdhPJzBsehD/h5388RG5wybKiHP5UOPu2hO9n5mcl7+MypauMnBZcK3Axz0jijycrZWhVS6aIUtlhDvgpMV6Agqofw=
X-Received: by 2002:a9d:72de:: with SMTP id d30mr11554750otk.18.1634355567902;
 Fri, 15 Oct 2021 20:39:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Fri, 15 Oct 2021 20:39:27
 -0700 (PDT)
In-Reply-To: <20211015130222.2976760-1-mmakassikis@freebox.fr>
References: <20211015130222.2976760-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 16 Oct 2021 12:39:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9fxn+aYH=g8Tj1-+vUwZ=F7ruFD71Y7U1FeX6VrG+Sng@mail.gmail.com>
Message-ID: <CAKYAXd9fxn+aYH=g8Tj1-+vUwZ=F7ruFD71Y7U1FeX6VrG+Sng@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add buffer validation in session setup
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Marios,
2021-10-15 22:02 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> Make sure the security buffer's length/offset are valid with regards to
> the packet length.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  fs/ksmbd/smb2pdu.c | 51 ++++++++++++++++++++++++++++------------------
>  1 file changed, 31 insertions(+), 20 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 005aa93a49d6..5fc766439f0f 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -1274,19 +1274,13 @@ static int generate_preauth_hash(struct ksmbd_work
> *work)
>  	return 0;
>  }
>
> -static int decode_negotiation_token(struct ksmbd_work *work,
> -				    struct negotiate_message *negblob)
> +static int decode_negotiation_token(struct ksmbd_conn *conn,
> +				    struct negotiate_message *negblob,
> +				    size_t sz)
>  {
> -	struct ksmbd_conn *conn = work->conn;
> -	struct smb2_sess_setup_req *req;
> -	int sz;
> -
>  	if (!conn->use_spnego)
>  		return -EINVAL;
>
> -	req = work->request_buf;
> -	sz = le16_to_cpu(req->SecurityBufferLength);
> -
>  	if (ksmbd_decode_negTokenInit((char *)negblob, sz, conn)) {
>  		if (ksmbd_decode_negTokenTarg((char *)negblob, sz, conn)) {
>  			conn->auth_mechs |= KSMBD_AUTH_NTLMSSP;
> @@ -1298,9 +1292,9 @@ static int decode_negotiation_token(struct ksmbd_work
> *work,
>  }
>
>  static int ntlm_negotiate(struct ksmbd_work *work,
> -			  struct negotiate_message *negblob)
> +			  struct negotiate_message *negblob,
> +			  size_t negblob_len)
>  {
> -	struct smb2_sess_setup_req *req = work->request_buf;
>  	struct smb2_sess_setup_rsp *rsp = work->response_buf;
>  	struct challenge_message *chgblob;
>  	unsigned char *spnego_blob = NULL;
> @@ -1309,8 +1303,7 @@ static int ntlm_negotiate(struct ksmbd_work *work,
>  	int sz, rc;
>
>  	ksmbd_debug(SMB, "negotiate phase\n");
> -	sz = le16_to_cpu(req->SecurityBufferLength);
> -	rc = ksmbd_decode_ntlmssp_neg_blob(negblob, sz, work->sess);
> +	rc = ksmbd_decode_ntlmssp_neg_blob(negblob, negblob_len, work->sess);
>  	if (rc)
>  		return rc;
>
> @@ -1378,12 +1371,20 @@ static struct ksmbd_user *session_user(struct
> ksmbd_conn *conn,
>  	struct authenticate_message *authblob;
>  	struct ksmbd_user *user;
>  	char *name;
> -	int sz;
> +	unsigned int name_off, name_len, pdu_len;
>
>  	authblob = user_authblob(conn, req);
we need to validate UserName first. so..
        if (le16_to_cpu(req->SecurityBufferLength) < sizeof(struct
authenticate_message)) {
                ksmbd_debug(SMB, "blob len %d too small\n",
                            le16_to_cpu(req->SecurityBufferLength));
                return NULL;
        }


> -	sz = le32_to_cpu(authblob->UserName.BufferOffset);
> -	name = smb_strndup_from_utf16((const char *)authblob + sz,
> -				      le16_to_cpu(authblob->UserName.Length),
> +	pdu_len = get_rfc1002_len(req) + 4;
> +	name_off = le32_to_cpu(authblob->UserName.BufferOffset);
> +	name_len = le16_to_cpu(authblob->UserName.Length);
> +
> +	if (((char *)authblob + name_off > (char *)req + pdu_len) ||
> +	    (sizeof(struct smb2_sess_setup_req) +
> +	    sizeof(struct authenticate_message) + name_len > pdu_len))
> +		return NULL;
Can we make it simpler ?
 auth_msg_len =  le16_to_cpu(req->SecurityBufferOffset) +
le16_to_cpu(req->SecurityBufferLength);
 if (auth_msg_len < (u64)name_off + name_len)
           return NULL;

And We need to validate the following ones in the same way in
ksmbd_decode_ntlmssp_auth_blob().

        struct security_buffer NtChallengeResponse;
        struct security_buffer DomainName;

> +
> +	name = smb_strndup_from_utf16((const char *)authblob + name_off,
> +				      name_len,
>  				      true,
>  				      conn->local_nls);
>  	if (IS_ERR(name)) {
> @@ -1629,6 +1630,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
>  	struct smb2_sess_setup_rsp *rsp = work->response_buf;
>  	struct ksmbd_session *sess;
>  	struct negotiate_message *negblob;
> +	unsigned int pdu_length, negblob_len, negblob_off;
>  	int rc = 0;
>
>  	ksmbd_debug(SMB, "Received request for session setup\n");
> @@ -1709,10 +1711,19 @@ int smb2_sess_setup(struct ksmbd_work *work)
>  	if (sess->state == SMB2_SESSION_EXPIRED)
>  		sess->state = SMB2_SESSION_IN_PROGRESS;
>
> +	pdu_length = get_rfc1002_len(req);
> +	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
> +	negblob_len = le16_to_cpu(req->SecurityBufferLength);
> +	if (negblob_off != (offsetof(struct smb2_sess_setup_req, Buffer) - 4))
if (negblob_off < (offsetof(struct smb2_sess_setup_req, Buffer) - 4))

> +		return -EINVAL;
> +
> +	/* account for Buffer[1] and smb2_buf_length */
> +	if (sizeof(struct smb2_sess_setup_req) + negblob_len - 1 > pdu_length +
> 4)
> +		return -EINVAL;
There is same check in ksmbd_smb2_check_message().  Please check it.

Thanks!
>  	negblob = (struct negotiate_message *)((char *)&req->hdr.ProtocolId +
> -			le16_to_cpu(req->SecurityBufferOffset));
> +			negblob_off);
>
> -	if (decode_negotiation_token(work, negblob) == 0) {
> +	if (decode_negotiation_token(conn, negblob, negblob_len) == 0) {
>  		if (conn->mechToken)
>  			negblob = (struct negotiate_message *)conn->mechToken;
>  	}
> @@ -1736,7 +1747,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
>  			sess->Preauth_HashValue = NULL;
>  		} else if (conn->preferred_auth_mech == KSMBD_AUTH_NTLMSSP) {
>  			if (negblob->MessageType == NtLmNegotiate) {
> -				rc = ntlm_negotiate(work, negblob);
> +				rc = ntlm_negotiate(work, negblob, negblob_len);
>  				if (rc)
>  					goto out_err;
>  				rsp->hdr.Status =
> --
> 2.25.1
>
>
