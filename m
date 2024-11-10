Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C8222615;
	Sun, 10 Nov 2024 01:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731200971; cv=none; b=Z2tEvZQtzQjHlFtZ9BmJeJhcWZgoP11IgBt9hxQnXvPN7qV4ktV30FYEH/r7ZKwVOzrpjzkJXMLWOwy9tCwfG8MqIfpm7GIQzSafkHF/D3AusKGV8XIeweDjkh32qQm1brWmx6Uc1f55HGv1rowQU5MvWxEscPWN+lpxC/KVB7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731200971; c=relaxed/simple;
	bh=j21Fe4MV22kbcDdJWgWk85nZgCPWCTU4DiYyDRdNSxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TPEJ4wZolNfRVXubOq8kguz7zhj398+5sP/CpM3qBgeQXt3UpU6G6v5QaT33xcXqfLaYb3RrmkOz1Gb1lqLPo6Dqdk/lbYdD+OicGtwdHOKFGfmEwY1uHejup2czK3ojTpK8dRTRe2/BNSvQ2uLKi6RrRNRa9K7WxBAcLgtrlRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=MCcdGXyb; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="MCcdGXyb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=34P4Gv5ZFLvOwD05Z5uiL4PwRRg9HBQ2fSEnVzZIaag=; b=MCcdGXybh+hhvHEl
	2IFnrSKsoUZHc9rePgcwV7zyIZ/c5tk8HSNv7Z4szGcWXvkxE5vif9v+qqTeXsYn6gZB0jQvui9RM
	mXhXSqY2B9ovT99EpXU68rKsTcsvocvTB9Z/XQHzPA+r4cUiUrUeiD9wuiOX7pyP+iPqCdWIV8Ml3
	ZNC4KqwoDiG5tZhELimaZWvu+lC9CzQrqwWXPKit2t5+EoJW4m5z4tRFsUIENUDap2SwqFCEECC0f
	PZmiqeOHaM+nfaT62lrsKge0bxopEoBOewBBktbObCRizsM8k8Z1xQ1ZcdzDkN3WNpkfg9EFZUHTr
	WPGzAIr3zK0mfMUbYw==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1t9wRx-00GTD0-3B;
	Sun, 10 Nov 2024 01:09:09 +0000
Date: Sun, 10 Nov 2024 01:09:09 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Tom Talpey <tom@talpey.com>
Cc: Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath S M <bharathsm@microsoft.com>,
	CIFS <linux-cifs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cifs: Remove pre-historic unused CIFSSMBCopy
Message-ID: <ZzAHtarHXvEJl60t@gallifrey>
References: <20241007210214.102568-1-linux@treblig.org>
 <Zy0reBfykkwXA47d@gallifrey>
 <CAH2r5mvL+xXH_nnoKKKnVPFo_xtOb=8mPSqrG28Dgngx6Aab7Q@mail.gmail.com>
 <CAH2r5ms1y3XsGmA2kU6Vdvdmg_jnVyd2w7mQPRyX9oh9rFD2tA@mail.gmail.com>
 <de669b49-ae19-4d22-96ab-c0fe4610f9dd@talpey.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <de669b49-ae19-4d22-96ab-c0fe4610f9dd@talpey.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 01:08:29 up 185 days, 12:22,  1 user,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Tom Talpey (tom@talpey.com) wrote:
> On 11/8/2024 11:09 PM, Steve French wrote:
> > As an alternative, might be useful to see if this command still works
> > to Samba and/or older Windows (and e.g. enable an ioctl for it - might
> > have been useful in the past to old servers)
> 
> Please let's not do anything to enhance usage of the hopelessly
> insecure SMB1 protocol. Especially not with something we just
> found in the back of the closet.
> 
> The MS-CIFS document has this to say about SMB_COM_COPY:
> 
> 2.2.4.37 SMB_COM_COPY (0x29)
> This command was introduced in the LAN Manager 1.0 dialect (see
> [SMB-LM1X] section 9.2.1 and [XOPEN-SMB] sections 14.1 and 15.2).
> It was rendered obsolete in the NT LAN Manager dialect. This
> command was used to perform server-side file copies, but is no
> longer used. Clients SHOULD NOT send requests using this command
> code. Servers receiving requests with this command code SHOULD
> return STATUS_NOT_IMPLEMENTED (ERRDOS/ERRbadfunc). <51>
> 
> <51> Section 2.2.4.37: Windows NT servers attempt to process this
> command, but the implementation is incomplete and the results are
> not predictable.

Thanks for doing the archaeology!

> Deletion-Enthusiastically-Acked-by: Tom Talpey <tom@talpey.com>

Haha, thanks!

Dave

> Tom.
> 
> > On Fri, Nov 8, 2024 at 10:06 PM Steve French <smfrench@gmail.com> wrote:
> > > 
> > > No objections to this from me. Will add it to for next next in the next few days so can queue it for 6.13-rc
> > > 
> > > On Thu, Nov 7, 2024, 3:11 PM Dr. David Alan Gilbert <linux@treblig.org> wrote:
> > > > 
> > > > * linux@treblig.org (linux@treblig.org) wrote:
> > > > > From: "Dr. David Alan Gilbert" <linux@treblig.org>
> > > > > 
> > > > > CIFSSMBCopy() is unused, remove it.
> > > > > 
> > > > > It seems to have been that way pre-git; looking in a historic
> > > > > archive, I think it landed around May 2004 in Linus'
> > > > > BKrev: 40ab7591J_OgkpHW-qhzZukvAUAw9g
> > > > > and was unused back then.
> > > > > 
> > > > > Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> > > > 
> > > > Ping?
> > > > 
> > > > Dave
> > > > 
> > > > > ---
> > > > >   fs/smb/client/cifsproto.h |  7 -----
> > > > >   fs/smb/client/cifssmb.c   | 63 ---------------------------------------
> > > > >   2 files changed, 70 deletions(-)
> > > > > 
> > > > > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> > > > > index 1d3470bca45e..8235b5a0aa2b 100644
> > > > > --- a/fs/smb/client/cifsproto.h
> > > > > +++ b/fs/smb/client/cifsproto.h
> > > > > @@ -549,13 +549,6 @@ extern int generate_smb311signingkey(struct cifs_ses *ses,
> > > > >                                     struct TCP_Server_Info *server);
> > > > > 
> > > > >   #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> > > > > -extern int CIFSSMBCopy(unsigned int xid,
> > > > > -                     struct cifs_tcon *source_tcon,
> > > > > -                     const char *fromName,
> > > > > -                     const __u16 target_tid,
> > > > > -                     const char *toName, const int flags,
> > > > > -                     const struct nls_table *nls_codepage,
> > > > > -                     int remap_special_chars);
> > > > >   extern ssize_t CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
> > > > >                        const unsigned char *searchName,
> > > > >                        const unsigned char *ea_name, char *EAData,
> > > > > diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> > > > > index c6f15dbe860a..ca50ac652e02 100644
> > > > > --- a/fs/smb/client/cifssmb.c
> > > > > +++ b/fs/smb/client/cifssmb.c
> > > > > @@ -2339,69 +2339,6 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
> > > > >        return rc;
> > > > >   }
> > > > > 
> > > > > -int
> > > > > -CIFSSMBCopy(const unsigned int xid, struct cifs_tcon *tcon,
> > > > > -         const char *fromName, const __u16 target_tid, const char *toName,
> > > > > -         const int flags, const struct nls_table *nls_codepage, int remap)
> > > > > -{
> > > > > -     int rc = 0;
> > > > > -     COPY_REQ *pSMB = NULL;
> > > > > -     COPY_RSP *pSMBr = NULL;
> > > > > -     int bytes_returned;
> > > > > -     int name_len, name_len2;
> > > > > -     __u16 count;
> > > > > -
> > > > > -     cifs_dbg(FYI, "In CIFSSMBCopy\n");
> > > > > -copyRetry:
> > > > > -     rc = smb_init(SMB_COM_COPY, 1, tcon, (void **) &pSMB,
> > > > > -                     (void **) &pSMBr);
> > > > > -     if (rc)
> > > > > -             return rc;
> > > > > -
> > > > > -     pSMB->BufferFormat = 0x04;
> > > > > -     pSMB->Tid2 = target_tid;
> > > > > -
> > > > > -     pSMB->Flags = cpu_to_le16(flags & COPY_TREE);
> > > > > -
> > > > > -     if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
> > > > > -             name_len = cifsConvertToUTF16((__le16 *) pSMB->OldFileName,
> > > > > -                                           fromName, PATH_MAX, nls_codepage,
> > > > > -                                           remap);
> > > > > -             name_len++;     /* trailing null */
> > > > > -             name_len *= 2;
> > > > > -             pSMB->OldFileName[name_len] = 0x04;     /* pad */
> > > > > -             /* protocol requires ASCII signature byte on Unicode string */
> > > > > -             pSMB->OldFileName[name_len + 1] = 0x00;
> > > > > -             name_len2 =
> > > > > -                 cifsConvertToUTF16((__le16 *)&pSMB->OldFileName[name_len+2],
> > > > > -                                    toName, PATH_MAX, nls_codepage, remap);
> > > > > -             name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
> > > > > -             name_len2 *= 2; /* convert to bytes */
> > > > > -     } else {
> > > > > -             name_len = copy_path_name(pSMB->OldFileName, fromName);
> > > > > -             pSMB->OldFileName[name_len] = 0x04;  /* 2nd buffer format */
> > > > > -             name_len2 = copy_path_name(pSMB->OldFileName+name_len+1, toName);
> > > > > -             name_len2++;    /* signature byte */
> > > > > -     }
> > > > > -
> > > > > -     count = 1 /* 1st signature byte */  + name_len + name_len2;
> > > > > -     inc_rfc1001_len(pSMB, count);
> > > > > -     pSMB->ByteCount = cpu_to_le16(count);
> > > > > -
> > > > > -     rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> > > > > -             (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> > > > > -     if (rc) {
> > > > > -             cifs_dbg(FYI, "Send error in copy = %d with %d files copied\n",
> > > > > -                      rc, le16_to_cpu(pSMBr->CopyCount));
> > > > > -     }
> > > > > -     cifs_buf_release(pSMB);
> > > > > -
> > > > > -     if (rc == -EAGAIN)
> > > > > -             goto copyRetry;
> > > > > -
> > > > > -     return rc;
> > > > > -}
> > > > > -
> > > > >   int
> > > > >   CIFSUnixCreateSymLink(const unsigned int xid, struct cifs_tcon *tcon,
> > > > >                      const char *fromName, const char *toName,
> > > > > --
> > > > > 2.46.2
> > > > > 
> > > > --
> > > >   -----Open up your eyes, open up your mind, open up your code -------
> > > > / Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \
> > > > \        dave @ treblig.org |                               | In Hex /
> > > >   \ _________________________|_____ http://www.treblig.org   |_______/
> > > > 
> > 
> > 
> 
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
