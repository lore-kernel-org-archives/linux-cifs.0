Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BF21F873E
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 19:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744227717; cv=none; b=Kvc5JCkvBv97IAxCHUKOP2LTwSG0v64kUkhbVX769JPOCWzDR6mlogX5UAxNUvoFTepJQ+SJtO9RExYXNqSay+Fx7+FB1DTPMHemyCpxzVrdxw0LhSboeajcb4WhbHTglQAZ4iTWsrSkUYVGCqQwId9ywd6TwQTyqPMWWLCf73g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744227717; c=relaxed/simple;
	bh=u9qzPVSgnzorBlRJcyYVAY6h3lFot1k4jdFM9mPNHsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BPw9RkqjOhr04bVC4/ZxBxwxpoMvi6tKDtzTZjgcxDBAiS+RK42jQUy+mzAnXuq5bE+NfPJh3bZPDBTRueBzMy41YZmPrhyEvfGzJxzVNG+cEuFecIOqz6sFssueVS6qYQq94Qm40YRxiH23udQYcEoXcwrH6b+WtrdtWP1gjL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=quBJ0aR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="quBJ0aR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBB9C4CEE2;
	Wed,  9 Apr 2025 19:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744227716;
	bh=u9qzPVSgnzorBlRJcyYVAY6h3lFot1k4jdFM9mPNHsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=quBJ0aR88Y/BnMVvMitZQRNjrifbZUnFeEgCOzlvxr+bMJ5cdkz7TTfdZ6Am0+o7H
	 eDWr2kRGQI63d9H8eGEHOiQtcYTgaWz4Zorrk94DZg93Jcd5B2paOWsxAU6tsYcNcy
	 BKkcfGWyJ0VBWkevSf2HKAlVbDc8yjjC/AR7C8nrH+oaAgAxmwDAXBdNGFG7q/lH+o
	 5FwRQI8HFABSVIF6GVyPqFXlD8kyKocUyhfn3dZzkT6DSZKoH3mg2xdaJG6nxm/4eh
	 oFcFeP0Y0jSM6xRBYabtolTaAvB80q0pZpHSz+gaAoS/ZIx+Adjf24Mq/ywW+RLC3W
	 stGu4ziW7ZAHg==
Received: by pali.im (Postfix)
	id 66E0F4B3; Wed,  9 Apr 2025 21:41:52 +0200 (CEST)
Date: Wed, 9 Apr 2025 21:41:52 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 03/25] cifs: Add support for SMB1 Session Setup NTLMSSP
Message-ID: <20250409194152.yf5u3ufw4ucknpxt@pali>
References: <CAH2r5msKV9ChZr6-2tQ3ZLSmS9D5s1SiOWGfbhCnVPMEKoDf_Q@mail.gmail.com>
 <20250409192208.eihyv566ralpl4zg@pali>
 <CAH2r5mug12QDNinQtSZHM4phzoVADwvsrL-a6f0iHXeJCj+qdg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mug12QDNinQtSZHM4phzoVADwvsrL-a6f0iHXeJCj+qdg@mail.gmail.com>
User-Agent: NeoMutt/20180716

I could try to check some older OS/2 server.

On Wednesday 09 April 2025 14:27:32 Steve French wrote:
> Are you aware of any servers which support NTLMSSP but not Unicode?
> 
> On Wed, Apr 9, 2025 at 2:22 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > I have tested it against Windows Server 2022 with new -o nounicode
> > option which turned off the Unicode support. Without this fix,
> > the mount with -o nounicode option and NTLMSSP was failing.
> >
> > On Wednesday 09 April 2025 13:39:58 Steve French wrote:
> > > Pali,
> > > Have you been able to verify this (your patch, attached) to any
> > > (presumably ancient?) server that actually wouldn't support Unicode
> > > and would support NTLMSSP? or was this only emulated by turning off
> > > Unicode (and if so which servers did you test it against?)
> > >
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> > > From 1d789f0843075395945aa30528fb17d6c517d054 Mon Sep 17 00:00:00 2001
> > > From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
> > > Date: Sun, 6 Oct 2024 19:24:29 +0200
> > > Subject: [PATCH 03/25] cifs: Add support for SMB1 Session Setup NTLMSSP
> > >  Request in non-UNICODE mode
> > > MIME-Version: 1.0
> > > Content-Type: text/plain; charset=UTF-8
> > > Content-Transfer-Encoding: 8bit
> > >
> > > SMB1 Session Setup NTLMSSP Request in non-UNICODE mode is similar to
> > > UNICODE mode, just strings are encoded in ASCII and not in UTF-16.
> > >
> > > With this change it is possible to setup SMB1 session with NTLM
> > > authentication in non-UNICODE mode with Windows SMB server.
> > >
> > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > ---
> > >  fs/smb/client/sess.c | 20 ++++++++++----------
> > >  1 file changed, 10 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > > index b3fa9ee26912..0f51d136cf23 100644
> > > --- a/fs/smb/client/sess.c
> > > +++ b/fs/smb/client/sess.c
> > > @@ -1684,22 +1684,22 @@ _sess_auth_rawntlmssp_assemble_req(struct sess_data *sess_data)
> > >       pSMB = (SESSION_SETUP_ANDX *)sess_data->iov[0].iov_base;
> > >
> > >       capabilities = cifs_ssetup_hdr(ses, server, pSMB);
> > > -     if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) {
> > > -             cifs_dbg(VFS, "NTLMSSP requires Unicode support\n");
> > > -             return -ENOSYS;
> > > -     }
> > > -
> > >       pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
> > >       capabilities |= CAP_EXTENDED_SECURITY;
> > >       pSMB->req.Capabilities |= cpu_to_le32(capabilities);
> > >
> > >       bcc_ptr = sess_data->iov[2].iov_base;
> > > -     /* unicode strings must be word aligned */
> > > -     if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
> > > -             *bcc_ptr = 0;
> > > -             bcc_ptr++;
> > > +
> > > +     if (pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) {
> > > +             /* unicode strings must be word aligned */
> > > +             if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
> > > +                     *bcc_ptr = 0;
> > > +                     bcc_ptr++;
> > > +             }
> > > +             unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
> > > +     } else {
> > > +             ascii_oslm_strings(&bcc_ptr, sess_data->nls_cp);
> > >       }
> > > -     unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
> > >
> > >       sess_data->iov[2].iov_len = (long) bcc_ptr -
> > >                                       (long) sess_data->iov[2].iov_base;
> > > --
> > > 2.43.0
> > >
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
