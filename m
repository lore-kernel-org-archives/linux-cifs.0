Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3DEC433ED
	for <linux-cifs@archiver.kernel.org>; Sun,  2 May 2021 23:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C469F61165
	for <linux-cifs@archiver.kernel.org>; Sun,  2 May 2021 23:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhEBXEC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 May 2021 19:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhEBXEB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 May 2021 19:04:01 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8803EC06174A
        for <linux-cifs@vger.kernel.org>; Sun,  2 May 2021 16:03:08 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id c3so1405615lfs.7
        for <linux-cifs@vger.kernel.org>; Sun, 02 May 2021 16:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6EO9YVJUkmjUm/S59BoYQHR0bnDmeJX+i6liR1jy1uw=;
        b=sjnP1HrMv5bwtrZyYaYMxbCBjARu+t20VzTHGTe4dTDCIZpU8byvg4gI59AE3IwWFR
         XvCjPlfcc0ck3d5aEUkd7InurBbD50u+Z2yS8Rp8b0aoXCDbLzDkT8tQGRQqHsUS0Xhg
         SWJzNhF9pDttyIg2lDvq7pPLBtS5/+ZF+g+LbUrXiNF2wSeE9JBN0nuSlCExGEQYgZr4
         q1SKMMlR9hyJXA+NO900y6pTx1dMkF+hKyOSO9Iv1vHkeFmW9e0urSgpiyjW/a0yJZWP
         qOuO2O+DeTQu9nbGsWY6K8lvx/2yqdAu+EvIyMQtqmcqXxKVqNyVvnyoz2UgHIETl9Xo
         ku+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6EO9YVJUkmjUm/S59BoYQHR0bnDmeJX+i6liR1jy1uw=;
        b=SYTN9WkWql6TanOvCSQlFJwcvfltaoXcoQNVq2b26S1J+mnW8Jw4Cd0ZOcCL8ySMMG
         Ijuq2M5kVLVEhYI/dt53gmBMfnLSmrU2metWdlTxjRz81lSq33ekLYAelzuMiqn2Yy2c
         kyUODfas2QuDn9xMNmEqLBiRHAnM0piC207zOtadSI2iRDCR8M9rgHWztWkU2fDp5vtU
         5eao7VCwkzDztLcPwZVA/BDbc242a2+NORrw+R5shzglJc6nn3GaeSPtQjXoZcHCnOYY
         BzpJdqn+AdevZnKJ7xWSnFRTgev9oqXuERCXoEwrkw2W0veOcUq6eSTVJPHOQUhy30xT
         FTmw==
X-Gm-Message-State: AOAM530l5DLumTomE2qMSot1EFg44BiiUIqH8+PY6Wz8ZPNVm452zJSx
        8P2R2uLbfgAufoRgqbNDT2+nidYGlhmFRYfi5Pw=
X-Google-Smtp-Source: ABdhPJyV78RccEK/YIVSgdCGxuccHt/C9pM7FRO6cXFfcMRFN0BjUvwEld2t4Uaa6vzYTHQGxGHvUHr8oFhfYPh1ITE=
X-Received: by 2002:ac2:5688:: with SMTP id 8mr1506736lfr.282.1619996586188;
 Sun, 02 May 2021 16:03:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muN3rpUur8jSav=fJfnt_vuJhgOXxMeGmXvT3KvxbBU5w@mail.gmail.com>
 <CAN05THQzSCZwypBWg9YZAarjrsQ74qowp4Bneo3crW9FfqVqPA@mail.gmail.com>
 <CAH2r5muu3YiBAk1Mf_xOFQJih8Ms7sQhNUKwUrFreggK-Mmr-A@mail.gmail.com>
 <CANT5p=rGGNdVjBSTZm1OsecEW=-5edZhZwBjSU1Q8d8dO+JsPA@mail.gmail.com>
 <CAN05THTmZCNXsH4_i=0CO6CaVOYuZ=z5XHW+U_=q3Djxz6XxBA@mail.gmail.com> <CAH2r5msrS0Ox86NgpfUrwv_MPEU7pYGdG=JfYwK9Btia6W8PLA@mail.gmail.com>
In-Reply-To: <CAH2r5msrS0Ox86NgpfUrwv_MPEU7pYGdG=JfYwK9Btia6W8PLA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 2 May 2021 18:02:55 -0500
Message-ID: <CAH2r5mugntjkFbsz0YCRZwsL0YTZRtb5ZNBUcPBx5nTTWPG_1w@mail.gmail.com>
Subject: Re: [PATCH] smb3.1.1: allow dumping GCM256 keys to improve debugging
 of encrypted shares
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>
Content-Type: multipart/mixed; boundary="0000000000000eb02505c160d97a"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000000eb02505c160d97a
Content-Type: text/plain; charset="UTF-8"

How about something like this to allow optional passing in of uid
(which you can get from /proc/fs/cifs) to dump keys for the multiuser
case?


On Sat, May 1, 2021 at 11:05 PM Steve French <smfrench@gmail.com> wrote:
>
> I think it is reasonably easy to read in an optional SUID (smb session
> uid) as a parm on the new "DUMP_FULL_KEY" ioctl - less code to add in
> the followon patch.  Will spin something up later tonight
>
> On Sat, May 1, 2021 at 3:49 PM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
> >
> > On Sat, May 1, 2021 at 8:53 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >
> > > Looks good to me.
> > >
> > > On a related note, we need a way for the root user to dump keys for
> > > another SMB session to the same path. This will be useful for
> > > mutli-user scenario.
> > > i.e. for dumping keys for SMB session as another user.
> > > Since we're adding a new IOCTL, perhaps we should add another arg
> > > which identifies the user? Maybe based on the UID:GID of the user
> > > session, in addition to the path supplied?
> >
> > Or as an alternative, dump an array of ALL user sessions with
> > information about which user and which part of a multi-channel
> > connection that the keys belong to.
> > And let userspace sort out "which keys do I need for my wireshark session".
> >
> > >
> > > Regards,
> > > Shyam
> > >
> > > On Sat, May 1, 2021 at 9:49 AM Steve French <smfrench@gmail.com> wrote:
> > > >
> > > > changed as suggested - see attached
> > > >
> > > > On Fri, Apr 30, 2021 at 11:00 PM ronnie sahlberg
> > > > <ronniesahlberg@gmail.com> wrote:
> > > > >
> > > > > These elements should probably be [32] and not
> > > > > + __u8 smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
> > > > >
> > > > > Because this is now visible to userspace and we can not allow this to
> > > > > ever change.
> > > > > Because when GCM512 is eventually released, if we bump
> > > > > SMB3_ENC_DEC_KEY_SIZE to a larger value we suddenly break userspace.
> > > > >
> > > > >
> > > > > On Sat, May 1, 2021 at 8:20 AM Steve French <smfrench@gmail.com> wrote:
> > > > > >
> > > > > > Previously we were only able to dump CCM or GCM-128 keys (see "smbinfo
> > > > > > keys" e.g.)
> > > > > > to allow network debugging (e.g. wireshark) of mounts to SMB3.1.1 encrypted
> > > > > > shares.  But with the addition of GCM-256 support, we have to be able to dump
> > > > > > 32 byte instead of 16 byte keys which requires adding an additional ioctl
> > > > > > for that.
> > > > > >
> > > > > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > > > > ---
> > > > > >  fs/cifs/cifs_ioctl.h | 19 +++++++++++++++++++
> > > > > >  fs/cifs/ioctl.c      | 33 +++++++++++++++++++++++++++++++++
> > > > > >  2 files changed, 52 insertions(+)
> > > > > >
> > > > > > diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
> > > > > > index f262c64516bc..9f2ed9cccb08 100644
> > > > > > --- a/fs/cifs/cifs_ioctl.h
> > > > > > +++ b/fs/cifs/cifs_ioctl.h
> > > > > > @@ -57,6 +57,12 @@ struct smb_query_info {
> > > > > >   /* char buffer[]; */
> > > > > >  } __packed;
> > > > > >
> > > > > > +/*
> > > > > > + * Dumping the commonly used 16 byte (e.g. CCM and GCM128) keys still supported
> > > > > > + * for backlevel compatibility, but is not sufficient for dumping the less
> > > > > > + * frequently used GCM256 (32 byte) keys (see the newer "CIFS_DUMP_FULL_KEY"
> > > > > > + * ioctl for dumping decryption info for GCM256 mounts)
> > > > > > + */
> > > > > >  struct smb3_key_debug_info {
> > > > > >   __u64 Suid;
> > > > > >   __u16 cipher_type;
> > > > > > @@ -65,6 +71,18 @@ struct smb3_key_debug_info {
> > > > > >   __u8 smb3decryptionkey[SMB3_SIGN_KEY_SIZE];
> > > > > >  } __packed;
> > > > > >
> > > > > > +/*
> > > > > > + * Dump full key (32 byte encrypt/decrypt keys instead of 16 bytes)
> > > > > > + * is needed if GCM256 (stronger encryption) negotiated
> > > > > > + */
> > > > > > +struct smb3_full_key_debug_info {
> > > > > > + __u64 Suid;
> > > > > > + __u16 cipher_type;
> > > > > > + __u8 auth_key[16]; /* SMB2_NTLMV2_SESSKEY_SIZE */
> > > > > > + __u8 smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
> > > > > > + __u8 smb3decryptionkey[SMB3_ENC_DEC_KEY_SIZE];
> > > > > > +} __packed;
> > > > > > +
> > > > > >  struct smb3_notify {
> > > > > >   __u32 completion_filter;
> > > > > >   bool watch_tree;
> > > > > > @@ -78,6 +96,7 @@ struct smb3_notify {
> > > > > >  #define CIFS_QUERY_INFO _IOWR(CIFS_IOCTL_MAGIC, 7, struct smb_query_info)
> > > > > >  #define CIFS_DUMP_KEY _IOWR(CIFS_IOCTL_MAGIC, 8, struct smb3_key_debug_info)
> > > > > >  #define CIFS_IOC_NOTIFY _IOW(CIFS_IOCTL_MAGIC, 9, struct smb3_notify)
> > > > > > +#define CIFS_DUMP_FULL_KEY _IOWR(CIFS_IOCTL_MAGIC, 10, struct
> > > > > > smb3_full_key_debug_info)
> > > > > >  #define CIFS_IOC_SHUTDOWN _IOR ('X', 125, __u32)
> > > > > >
> > > > > >  /*
> > > > > > diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> > > > > > index ef41fa878793..e4321e2a27d2 100644
> > > > > > --- a/fs/cifs/ioctl.c
> > > > > > +++ b/fs/cifs/ioctl.c
> > > > > > @@ -218,6 +218,7 @@ long cifs_ioctl(struct file *filep, unsigned int
> > > > > > command, unsigned long arg)
> > > > > >  {
> > > > > >   struct inode *inode = file_inode(filep);
> > > > > >   struct smb3_key_debug_info pkey_inf;
> > > > > > + struct smb3_full_key_debug_info pfull_key_inf;
> > > > > >   int rc = -ENOTTY; /* strange error - but the precedent */
> > > > > >   unsigned int xid;
> > > > > >   struct cifsFileInfo *pSMBFile = filep->private_data;
> > > > > > @@ -354,6 +355,38 @@ long cifs_ioctl(struct file *filep, unsigned int
> > > > > > command, unsigned long arg)
> > > > > >   else
> > > > > >   rc = 0;
> > > > > >   break;
> > > > > > + /*
> > > > > > + * Dump full key (32 bytes instead of 16 bytes) is
> > > > > > + * needed if GCM256 (stronger encryption) negotiated
> > > > > > + */
> > > > > > + case CIFS_DUMP_FULL_KEY:
> > > > > > + if (pSMBFile == NULL)
> > > > > > + break;
> > > > > > + if (!capable(CAP_SYS_ADMIN)) {
> > > > > > + rc = -EACCES;
> > > > > > + break;
> > > > > > + }
> > > > > > +
> > > > > > + tcon = tlink_tcon(pSMBFile->tlink);
> > > > > > + if (!smb3_encryption_required(tcon)) {
> > > > > > + rc = -EOPNOTSUPP;
> > > > > > + break;
> > > > > > + }
> > > > > > + pfull_key_inf.cipher_type =
> > > > > > + le16_to_cpu(tcon->ses->server->cipher_type);
> > > > > > + pfull_key_inf.Suid = tcon->ses->Suid;
> > > > > > + memcpy(pfull_key_inf.auth_key, tcon->ses->auth_key.response,
> > > > > > + 16 /* SMB2_NTLMV2_SESSKEY_SIZE */);
> > > > > > + memcpy(pfull_key_inf.smb3decryptionkey,
> > > > > > +       tcon->ses->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZE);
> > > > > > + memcpy(pfull_key_inf.smb3encryptionkey,
> > > > > > +       tcon->ses->smb3encryptionkey, SMB3_ENC_DEC_KEY_SIZE);
> > > > > > + if (copy_to_user((void __user *)arg, &pfull_key_inf,
> > > > > > + sizeof(struct smb3_full_key_debug_info)))
> > > > > > + rc = -EFAULT;
> > > > > > + else
> > > > > > + rc = 0;
> > > > > > + break;
> > > > > >   case CIFS_IOC_NOTIFY:
> > > > > >   if (!S_ISDIR(inode->i_mode)) {
> > > > > >   /* Notify can only be done on directories */
> > > > > >
> > > > > > --
> > > > > > Thanks,
> > > > > >
> > > > > > Steve
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> > >
> > >
> > >
> > > --
> > > Regards,
> > > Shyam
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--0000000000000eb02505c160d97a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3.1.1-allow-dumping-keys-for-multiuser-mounts.patch"
Content-Disposition: attachment; 
	filename="0001-smb3.1.1-allow-dumping-keys-for-multiuser-mounts.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ko7s4fxc0>
X-Attachment-Id: f_ko7s4fxc0

RnJvbSBhNDg1M2VmNGRmMjU4YWU5YzhhYThiOTU1ZGRlNDRkOGVmMTYyNWQ1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMiBNYXkgMjAyMSAxNzozOTozMCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjMuMS4xOiBhbGxvdyBkdW1waW5nIGtleXMgZm9yIG11bHRpdXNlciBtb3VudHMKCldoZW4gbW91
bnRlZCBtdWx0aXVzZXIgaXQgaXMgaGFyZCB0byBkdW1wIGtleXMgZm9yIHRoZSBvdGhlciBzZXNz
aW9ucwp3aGljaCBtYWtlcyBpdCBoYXJkIHRvIGRlYnVnIHVzaW5nIG5ldHdvcmsgdHJhY2VzIChl
LmcuIHVzaW5nIHdpcmVzaGFyaykuCgpTdWdnZXN0ZWQtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJh
c2FkQG1pY3Jvc29mdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hA
bWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2lvY3RsLmMgfCA2NiArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNDYgaW5z
ZXJ0aW9ucygrKSwgMjAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9pb2N0bC5j
IGIvZnMvY2lmcy9pb2N0bC5jCmluZGV4IDdkOTY1NGY1NmVkYy4uMzc0NzZjZTEzZGU5IDEwMDY0
NAotLS0gYS9mcy9jaWZzL2lvY3RsLmMKKysrIGIvZnMvY2lmcy9pb2N0bC5jCkBAIC0yMTQsMTEg
KzIxNCw1NCBAQCBzdGF0aWMgaW50IGNpZnNfc2h1dGRvd24oc3RydWN0IHN1cGVyX2Jsb2NrICpz
YiwgdW5zaWduZWQgbG9uZyBhcmcpCiAJcmV0dXJuIDA7CiB9CiAKK3N0YXRpYyBpbnQgY2lmc19k
dW1wX2Z1bGxfa2V5KHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIHVuc2lnbmVkIGxvbmcgYXJnKQor
eworCXN0cnVjdCBzbWIzX2Z1bGxfa2V5X2RlYnVnX2luZm8gcGZ1bGxfa2V5X2luZjsKKwlfX3U2
NCBzdWlkOworCXN0cnVjdCBsaXN0X2hlYWQgKnRtcDsKKwlzdHJ1Y3QgY2lmc19zZXMgKnNlczsK
Kwlib29sIGZvdW5kID0gZmFsc2U7CisKKwlpZiAoIXNtYjNfZW5jcnlwdGlvbl9yZXF1aXJlZCh0
Y29uKSkKKwkJcmV0dXJuIC1FT1BOT1RTVVBQOworCisJc2VzID0gdGNvbi0+c2VzOyAvKiBkZWZh
dWx0IHRvIHVzZXIgaWQgZm9yIGN1cnJlbnQgdXNlciAqLworCWlmIChnZXRfdXNlcihzdWlkLCAo
X191MzIgX191c2VyICopYXJnKSkKKwkJc3VpZCA9IDA7CisJaWYgKHN1aWQpIHsKKwkJLyogc2Vh
cmNoIHRvIHNlZSBpZiB0aGVyZSBpcyBhIHNlc3Npb24gd2l0aCBhIG1hdGNoaW5nIFNNQiBVSUQg
Ki8KKwkJc3Bpbl9sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CisJCWxpc3RfZm9yX2VhY2godG1w
LCAmdGNvbi0+c2VzLT5zZXJ2ZXItPnNtYl9zZXNfbGlzdCkgeworCQkJc2VzID0gbGlzdF9lbnRy
eSh0bXAsIHN0cnVjdCBjaWZzX3Nlcywgc21iX3Nlc19saXN0KTsKKwkJCWlmIChzZXMtPlN1aWQg
PT0gc3VpZCkgeworCQkJCWZvdW5kID0gdHJ1ZTsKKwkJCQlicmVhazsKKwkJCX0KKwkJfQorCQlz
cGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOworCQlpZiAoZm91bmQgPT0gZmFsc2UpCisJ
CQlyZXR1cm4gLUVJTlZBTDsKKwl9IC8qIGVsc2UgdXNlcyBkZWZhdWx0IHVzZXIncyBTTUIgVUlE
IChpZSBjdXJyZW50IHVzZXIpICovCisKKwlwZnVsbF9rZXlfaW5mLmNpcGhlcl90eXBlID0gbGUx
Nl90b19jcHUoc2VzLT5zZXJ2ZXItPmNpcGhlcl90eXBlKTsKKwlwZnVsbF9rZXlfaW5mLlN1aWQg
PSBzZXMtPlN1aWQ7CisJbWVtY3B5KHBmdWxsX2tleV9pbmYuYXV0aF9rZXksIHNlcy0+YXV0aF9r
ZXkucmVzcG9uc2UsCisJICAgICAgIDE2IC8qIFNNQjJfTlRMTVYyX1NFU1NLRVlfU0laRSAqLyk7
CisJbWVtY3B5KHBmdWxsX2tleV9pbmYuc21iM2RlY3J5cHRpb25rZXksIHNlcy0+c21iM2RlY3J5
cHRpb25rZXksCisJICAgICAgIDMyIC8qIFNNQjNfRU5DX0RFQ19LRVlfU0laRSAqLyk7CisJbWVt
Y3B5KHBmdWxsX2tleV9pbmYuc21iM2VuY3J5cHRpb25rZXksCisJICAgICAgIHNlcy0+c21iM2Vu
Y3J5cHRpb25rZXksIDMyIC8qIFNNQjNfRU5DX0RFQ19LRVlfU0laRSAqLyk7CisJaWYgKGNvcHlf
dG9fdXNlcigodm9pZCBfX3VzZXIgKilhcmcsICZwZnVsbF9rZXlfaW5mLAorCQkJIHNpemVvZihz
dHJ1Y3Qgc21iM19mdWxsX2tleV9kZWJ1Z19pbmZvKSkpCisJCXJldHVybiAtRUZBVUxUOworCisJ
cmV0dXJuIDA7Cit9CisKIGxvbmcgY2lmc19pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZXAsIHVuc2ln
bmVkIGludCBjb21tYW5kLCB1bnNpZ25lZCBsb25nIGFyZykKIHsKIAlzdHJ1Y3QgaW5vZGUgKmlu
b2RlID0gZmlsZV9pbm9kZShmaWxlcCk7CiAJc3RydWN0IHNtYjNfa2V5X2RlYnVnX2luZm8gcGtl
eV9pbmY7Ci0Jc3RydWN0IHNtYjNfZnVsbF9rZXlfZGVidWdfaW5mbyBwZnVsbF9rZXlfaW5mOwog
CWludCByYyA9IC1FTk9UVFk7IC8qIHN0cmFuZ2UgZXJyb3IgLSBidXQgdGhlIHByZWNlZGVudCAq
LwogCXVuc2lnbmVkIGludCB4aWQ7CiAJc3RydWN0IGNpZnNGaWxlSW5mbyAqcFNNQkZpbGUgPSBm
aWxlcC0+cHJpdmF0ZV9kYXRhOwpAQCAtMzY2LDI2ICs0MDksOSBAQCBsb25nIGNpZnNfaW9jdGwo
c3RydWN0IGZpbGUgKmZpbGVwLCB1bnNpZ25lZCBpbnQgY29tbWFuZCwgdW5zaWduZWQgbG9uZyBh
cmcpCiAJCQkJcmMgPSAtRUFDQ0VTOwogCQkJCWJyZWFrOwogCQkJfQotCiAJCQl0Y29uID0gdGxp
bmtfdGNvbihwU01CRmlsZS0+dGxpbmspOwotCQkJaWYgKCFzbWIzX2VuY3J5cHRpb25fcmVxdWly
ZWQodGNvbikpIHsKLQkJCQlyYyA9IC1FT1BOT1RTVVBQOwotCQkJCWJyZWFrOwotCQkJfQotCQkJ
cGZ1bGxfa2V5X2luZi5jaXBoZXJfdHlwZSA9Ci0JCQkJbGUxNl90b19jcHUodGNvbi0+c2VzLT5z
ZXJ2ZXItPmNpcGhlcl90eXBlKTsKLQkJCXBmdWxsX2tleV9pbmYuU3VpZCA9IHRjb24tPnNlcy0+
U3VpZDsKLQkJCW1lbWNweShwZnVsbF9rZXlfaW5mLmF1dGhfa2V5LCB0Y29uLT5zZXMtPmF1dGhf
a2V5LnJlc3BvbnNlLAotCQkJCQkxNiAvKiBTTUIyX05UTE1WMl9TRVNTS0VZX1NJWkUgKi8pOwot
CQkJbWVtY3B5KHBmdWxsX2tleV9pbmYuc21iM2RlY3J5cHRpb25rZXksCi0JCQkgICAgICB0Y29u
LT5zZXMtPnNtYjNkZWNyeXB0aW9ua2V5LCAzMiAvKiBTTUIzX0VOQ19ERUNfS0VZX1NJWkUgKi8p
OwotCQkJbWVtY3B5KHBmdWxsX2tleV9pbmYuc21iM2VuY3J5cHRpb25rZXksCi0JCQkgICAgICB0
Y29uLT5zZXMtPnNtYjNlbmNyeXB0aW9ua2V5LCAzMiAvKiBTTUIzX0VOQ19ERUNfS0VZX1NJWkUg
Ki8pOwotCQkJaWYgKGNvcHlfdG9fdXNlcigodm9pZCBfX3VzZXIgKilhcmcsICZwZnVsbF9rZXlf
aW5mLAotCQkJCQlzaXplb2Yoc3RydWN0IHNtYjNfZnVsbF9rZXlfZGVidWdfaW5mbykpKQotCQkJ
CXJjID0gLUVGQVVMVDsKLQkJCWVsc2UKLQkJCQlyYyA9IDA7CisJCQljaWZzX2R1bXBfZnVsbF9r
ZXkodGNvbiwgYXJnKTsKKwogCQkJYnJlYWs7CiAJCWNhc2UgQ0lGU19JT0NfTk9USUZZOgogCQkJ
aWYgKCFTX0lTRElSKGlub2RlLT5pX21vZGUpKSB7Ci0tIAoyLjI3LjAKCg==
--0000000000000eb02505c160d97a--
