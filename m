Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E61C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Oct 2021 14:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E8766115A
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Oct 2021 14:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhJSOhN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Oct 2021 10:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJSOhN (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 19 Oct 2021 10:37:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F12C6115A
        for <linux-cifs@vger.kernel.org>; Tue, 19 Oct 2021 14:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634654100;
        bh=ddcaRR8MbNiqk6dyGqxpHSQoDSJYs2HlPbaq54vHAYM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=bGVZ9HE7/AZwVI1sjEFccK9nJ0AnBh8U2eqcDN2p36o4C4N1nKR+IAnJXOzcw8M1g
         yxAhvSx7Biyu3u/mWkKwgXJjruyEoWTvwLFHH0h252P+vERRZOI8MdikeBQh6eePKb
         Zp8PPYuPAeaZYo9p/jwTfthTv7zfHwhAbk3Hd8xGn0jfZ2jEGad4beqcL0b5I6fKTP
         S6n+98OnwECjLbw5tjVM8GhmKrbkRUsLIcaeCNHnlIleUMICHYvqJ2lRq+K57iBK6t
         c5JClJY3+znFEsVUFuzmRbyBAOqoaPTqsraw9bnp9f9CamLShbny5qt9JYShbcZrI/
         bG+NhQM1askow==
Received: by mail-ot1-f49.google.com with SMTP id p6-20020a9d7446000000b0054e6bb223f3so1894385otk.3
        for <linux-cifs@vger.kernel.org>; Tue, 19 Oct 2021 07:35:00 -0700 (PDT)
X-Gm-Message-State: AOAM530YTQujMyVhHL+zCuEIxeLWql6+MYwl3xxIi1I+MDcIopTRH0rq
        e7x6IGo0WQFDrZ3bgI7xAF96IDFYBR753iXxazo=
X-Google-Smtp-Source: ABdhPJxNcbtqHU0AkUjdEKtNDeMksWr6TNP02CEIvQeX0q2BwvsSPgXRwvfvsg0KauYSXeLIbAg71nZHPDVRLaSiuWo=
X-Received: by 2002:a05:6830:17da:: with SMTP id p26mr5588473ota.116.1634654099711;
 Tue, 19 Oct 2021 07:34:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Tue, 19 Oct 2021 07:34:59
 -0700 (PDT)
In-Reply-To: <20211019083641.116783-1-mmakassikis@freebox.fr>
References: <20211019083641.116783-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 19 Oct 2021 23:34:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9zvLy+Pyw++cnRRMqURSP1Pg51nqXW9Q84uCvCToCPXg@mail.gmail.com>
Message-ID: <CAKYAXd9zvLy+Pyw++cnRRMqURSP1Pg51nqXW9Q84uCvCToCPXg@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: add buffer validation in session setup
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-19 17:36 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> Make sure the security buffer's length/offset are valid with regards to
> the packet length.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  Changes since v2:
>  - check that negblob in smb2_sess_setup() is large enough to access the
>    MessageType field
>
> fs/ksmbd/auth.c    | 18 ++++++++++------
>  fs/ksmbd/smb2pdu.c | 51 ++++++++++++++++++++++++++++------------------
>  2 files changed, 43 insertions(+), 26 deletions(-)
>
> diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
> index 71c989f1568d..c9d32fea5669 100644
> --- a/fs/ksmbd/auth.c
> +++ b/fs/ksmbd/auth.c
> @@ -298,8 +298,9 @@ int ksmbd_decode_ntlmssp_auth_blob(struct
> authenticate_message *authblob,
>  				   int blob_len, struct ksmbd_session *sess)
>  {
>  	char *domain_name;
> -	unsigned int lm_off, nt_off;
> -	unsigned short nt_len;
> +	uintptr_t auth_msg_off;
> +	unsigned int lm_off, nt_off, dn_off;
> +	unsigned short nt_len, dn_len;
>  	int ret;
>
>  	if (blob_len < sizeof(struct authenticate_message)) {
> @@ -314,15 +315,20 @@ int ksmbd_decode_ntlmssp_auth_blob(struct
> authenticate_message *authblob,
>  		return -EINVAL;
>  	}
>
> +	auth_msg_off = (uintptr_t)((char *)authblob + blob_len);
>  	lm_off = le32_to_cpu(authblob->LmChallengeResponse.BufferOffset);
Let's remove unused lm_off.
>  	nt_off = le32_to_cpu(authblob->NtChallengeResponse.BufferOffset);
>  	nt_len = le16_to_cpu(authblob->NtChallengeResponse.Length);
> +	dn_off = le32_to_cpu(authblob->DomainName.BufferOffset);
> +	dn_len = le16_to_cpu(authblob->DomainName.Length);
> +
> +	if (auth_msg_off < (u64)dn_off + dn_len ||
It should be blob_len instead of auth_msg_off ?
> +	    auth_msg_off < (u64)nt_off + nt_len)
> +		return -EINVAL;
>
>  	/* TODO : use domain name that imported from configuration file */
> -	domain_name = smb_strndup_from_utf16((const char *)authblob +
> -			le32_to_cpu(authblob->DomainName.BufferOffset),
> -			le16_to_cpu(authblob->DomainName.Length), true,
> -			sess->conn->local_nls);
> +	domain_name = smb_strndup_from_utf16((const char *)authblob + dn_off,
> +					     dn_len, true, sess->conn->local_nls);
>  	if (IS_ERR(domain_name))
>  		return PTR_ERR(domain_name);
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 005aa93a49d6..f02766b1e9ce 100644
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
> @@ -1378,12 +1371,23 @@ static struct ksmbd_user *session_user(struct
> ksmbd_conn *conn,
>  	struct authenticate_message *authblob;
>  	struct ksmbd_user *user;
>  	char *name;
> -	int sz;
> +	unsigned int auth_msg_len, name_off, name_len, secbuf_len;
>
> +	secbuf_len = le16_to_cpu(req->SecurityBufferLength);
> +	if (secbuf_len < sizeof(struct authenticate_message)) {
> +		ksmbd_debug(SMB, "blob len %d too small\n", secbuf_len);
> +		return NULL;
> +	}
>  	authblob = user_authblob(conn, req);
> -	sz = le32_to_cpu(authblob->UserName.BufferOffset);
> -	name = smb_strndup_from_utf16((const char *)authblob + sz,
> -				      le16_to_cpu(authblob->UserName.Length),
> +	name_off = le32_to_cpu(authblob->UserName.BufferOffset);
> +	name_len = le16_to_cpu(authblob->UserName.Length);
> +	auth_msg_len = le16_to_cpu(req->SecurityBufferOffset) + secbuf_len;
> +
> +	if (auth_msg_len < (u64)name_off + name_len)
> +		return NULL;
> +
> +	name = smb_strndup_from_utf16((const char *)authblob + name_off,
> +				      name_len,
>  				      true,
>  				      conn->local_nls);
>  	if (IS_ERR(name)) {
> @@ -1629,6 +1633,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
>  	struct smb2_sess_setup_rsp *rsp = work->response_buf;
>  	struct ksmbd_session *sess;
>  	struct negotiate_message *negblob;
> +	unsigned int negblob_len, negblob_off;
>  	int rc = 0;
>
>  	ksmbd_debug(SMB, "Received request for session setup\n");
> @@ -1709,10 +1714,16 @@ int smb2_sess_setup(struct ksmbd_work *work)
>  	if (sess->state == SMB2_SESSION_EXPIRED)
>  		sess->state = SMB2_SESSION_IN_PROGRESS;
>
> +	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
> +	negblob_len = le16_to_cpu(req->SecurityBufferLength);
> +	if (negblob_off < (offsetof(struct smb2_sess_setup_req, Buffer) - 4) ||
> +	    negblob_len < offsetof(struct negotiate_message, NegotiateFlags))
> +		return -EINVAL;
> +
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
