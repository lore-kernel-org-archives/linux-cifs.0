Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A981C433B4
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 00:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55AD46141E
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 00:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhD3AIg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Apr 2021 20:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhD3AIg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Apr 2021 20:08:36 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BED3C06138B
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 17:07:48 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id d15so27359530ljo.12
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 17:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YEvRJw91sU9L/q6OzMWukIrfRiEczVSyOLVDRDOK09I=;
        b=aMW5CwIBGgXcrFn11YwkXCZy9mJn269fXaX34eJQtv9NJw5avnBqBQNhab6ZQarBXQ
         StnqFy7VOzTOMGR3nRfv09tpAAs3nLFizgvp4K1o7X2ZNpYqH5gtIihkzESltN9LRGzJ
         zfiWI1YJtkZ+vukNVXiqvkatqZuPfruRMfvtWwrjYA9Ygd9tY9mpIbLofxY1BDq/ZPTc
         hMrSHjW01rdNYbiHqAJEEMzKvdsGWCKd1rnMJAaAE30r8Y1B4D6KsexYikTrF9IPYcAu
         y/UH3BO2qELJ9UI6CrStdhnPWIqtzS8Qccbd3+BJVcqxAZ3JTIp/Ucf3Aedsy8LiTrMY
         1Y+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YEvRJw91sU9L/q6OzMWukIrfRiEczVSyOLVDRDOK09I=;
        b=jlY0+xTMNLdderTopXW4xpYwl1DVMx6Baja58tY3/r5lcbhTkgc5Fj7aYYTCtRfCbA
         O/l/2sUusX0abFAKoH3z1jnjvAZdMQy1tEos/wNmM7xRLAopKtgtFrzvcjnU6whvNLtl
         fWVONbQyTuj/elddB5tS/hfg5PCQiZRsJ/737WVuzrq/MVxzbyvZoe6JHpZ0Z3NE0MOB
         vmqsSD50pp4J7+SAex+EAZxVUm/te3Ahy9Ui8JhOBNgf6LTz2383M44+s1eR3ILmnsGG
         XpWJqZokQA4t+nXqTr8Qy/84c5ULGMw4605UeKGzSycTfvoCHN8b4cwT2/qq5CuKMmrn
         mSUA==
X-Gm-Message-State: AOAM533A64D8B/3BmQhiz6EIAu3xUb8BigMkuE2loIq1RkaWpEBlXm7U
        HYM6I9vp+XbwUDREGC6FKXulCorDmQovhUX7X7Ef8wChtxM=
X-Google-Smtp-Source: ABdhPJwp/Yxu8xBr9TvM86y6p1vHruL0be3oZviZv2OPC2b/o+zLQm2jarfmPKbiUTKo8vAoXHRU/5sLfzDxS1hqt64=
X-Received: by 2002:a2e:6e03:: with SMTP id j3mr1621505ljc.218.1619741266863;
 Thu, 29 Apr 2021 17:07:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvKfohJ=NkkCM7AxqRYq2+D8kRMTxP3VdG=W0s72Cdh0A@mail.gmail.com>
 <8735v9wiad.fsf@suse.com> <CAH2r5msnQ4YjJee2FSKPRknNEWsD61V-hvw15m7L3_qBY+Nk1g@mail.gmail.com>
In-Reply-To: <CAH2r5msnQ4YjJee2FSKPRknNEWsD61V-hvw15m7L3_qBY+Nk1g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Apr 2021 19:07:35 -0500
Message-ID: <CAH2r5msgAWp6wp9f21asTPqkuTcg5RtYm+pqK8etZ_zdej3=7Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: add shutdown support
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d7470705c12566cb"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d7470705c12566cb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Updated patch attached.   Fixed the remount issue (remount should
clear the shutdown flag). See below simple demonstration:

root@smfrench-ThinkPad-P52:~# mount | grep cifs
//localhost/test on /mnt1 type cifs
(rw,relatime,vers=3D3.1.1,cache=3Dstrict,username=3Dsmfrench,uid=3D0,noforc=
euid,gid=3D0,noforcegid,addr=3D127.0.0.1,file_mode=3D0755,dir_mode=3D0755,s=
oft,nounix,serverino,mapposix,noperm,rsize=3D4194304,wsize=3D4194304,bsize=
=3D1048576,echo_interval=3D60,actimeo=3D1)
root@smfrench-ThinkPad-P52:~# touch /mnt1/file
root@smfrench-ThinkPad-P52:~# ~smfrench/xfstests-dev/src/godown /mnt1/
root@smfrench-ThinkPad-P52:~# touch /mnt1/file
touch: cannot touch '/mnt1/file': Input/output error
root@smfrench-ThinkPad-P52:~# mount -t cifs //localhost/test /mnt1 -o remou=
nt
root@smfrench-ThinkPad-P52:~# touch /mnt1/file

On Thu, Apr 29, 2021 at 1:39 PM Steve French <smfrench@gmail.com> wrote:
>
> You are correct - I have to add the code to clear the bit on remount
>
> I have added your other changes and will send updated patch after lunch
>
> root@smfrench-ThinkPad-P52:~# mount | grep cifs
> //localhost/test on /mnt1 type cifs
> (rw,relatime,vers=3D3.1.1,cache=3Dstrict,username=3Dsmfrench,uid=3D0,nofo=
rceuid,gid=3D0,noforcegid,addr=3D127.0.0.1,file_mode=3D0755,dir_mode=3D0755=
,soft,nounix,serverino,mapposix,noperm,rsize=3D4194304,wsize=3D4194304,bsiz=
e=3D1048576,echo_interval=3D60,actimeo=3D1)
> root@smfrench-ThinkPad-P52:~# touch /mnt1/file
> root@smfrench-ThinkPad-P52:~# ~smfrench/xfstests-dev/src/godown /mnt1/
> root@smfrench-ThinkPad-P52:~# touch /mnt1/file
> touch: cannot touch '/mnt1/file': Input/output error
> root@smfrench-ThinkPad-P52:~# mount -o remount /mnt1
> root@smfrench-ThinkPad-P52:~# touch /mnt1/file
> touch: cannot touch '/mnt1/file': Input/output error
>
> On Thu, Apr 29, 2021 at 4:29 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wro=
te:
> >
> >
> > Do we need to add code to clear the flag on remount or is it implicitel=
y
> > cleared by not copying it?
> >
> > Steve French <smfrench@gmail.com> writes:
> > >  #define CIFS_MOUNT_MODE_FROM_SID 0x10000000 /* retrieve mode from
> > > special ACE */
> > >  #define CIFS_MOUNT_RO_CACHE 0x20000000  /* assumes share will not ch=
ange */
> > >  #define CIFS_MOUNT_RW_CACHE 0x40000000  /* assumes only client acces=
sing */
> > > +#define SMB3_MOUNT_SHUTDOWN 0x80000000
> >
> > While I totally understand wanting to remove the "cifs" name, those
> > flags are specific to the kernel & filesystem and have nothing to do
> > with the wire protocol so in this case I would rather use CIFS_ prefix
> > because SMB3_ is misleading and all the other flags are already using C=
IFS_.
> >
> > One day we should do s/CIFS/SMBFS/i on the whole tree where CIFS refers
> > to kernel stuff (not protocol) and rename the module smbfs. But that's =
a
> > story for another day I guess.
> >
> > >
> > >  struct cifs_sb_info {
> > >   struct rb_root tlink_tree;
> > > diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
> > > index 153d5c842a9b..a744022d2a71 100644
> > > --- a/fs/cifs/cifs_ioctl.h
> > > +++ b/fs/cifs/cifs_ioctl.h
> > > @@ -78,3 +78,19 @@ struct smb3_notify {
> > >  #define CIFS_QUERY_INFO _IOWR(CIFS_IOCTL_MAGIC, 7, struct smb_query_=
info)
> > >  #define CIFS_DUMP_KEY _IOWR(CIFS_IOCTL_MAGIC, 8, struct smb3_key_deb=
ug_info)
> > >  #define CIFS_IOC_NOTIFY _IOW(CIFS_IOCTL_MAGIC, 9, struct smb3_notify=
)
> > > +#define SMB3_IOC_SHUTDOWN _IOR ('X', 125, __u32)
> >
> > Same
> >
> > > +
> > > +/*
> > > + * Flags for going down operation
> > > + */
> > > +#define SMB3_GOING_FLAGS_DEFAULT                0x0     /* going dow=
n */
> > > +#define SMB3_GOING_FLAGS_LOGFLUSH               0x1     /* flush log
> > > but not data */
> > > +#define SMB3_GOING_FLAGS_NOLOGFLUSH             0x2     /* don't
> >
> > Same
> >
> > > flush log nor data */
> > > +
> > > +static inline bool smb3_forced_shutdown(struct cifs_sb_info *sbi)
> >
> > Same
> >
> > > +     cifs_dbg(VFS, "shut down requested (%d)", flags); /* BB FIXME *=
/
> > > +/*   trace_smb3_shutdown(sb, flags);*/
> >
> > What is there to fix? It's doing like ext4 so it's fine no?
> >
> > > +
> > > +     /*
> > > +      * see:
> > > +      *   https://man7.org/linux/man-pages/man2/ioctl_xfs_goingdown.=
2.html
> > > +      * for more information and description of original intent of t=
he flags
> > > +      */
> > > +     switch (flags) {
> > > +     /*
> > > +      * We could add support later for default flag which requires:
> > > +      *     "Flush all dirty data and metadata to disk"
> > > +      * would need to call syncfs or equivalent to flush page cache =
for
> > > +      * the mount and then issue fsync to server (if nostrictsync no=
t set)
> > > +      */
> > > +     case SMB3_GOING_FLAGS_DEFAULT:
> > > +             cifs_dbg(VFS, "default flags\n");
> >
> > Should this be removed, less verbose or more info should be printed?
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000d7470705c12566cb
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-cifs-add-shutdown-support.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-add-shutdown-support.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ko3k2rlo0>
X-Attachment-Id: f_ko3k2rlo0

RnJvbSA2ZjQ3YTQ5NjU5ODVmNGNjYjI5ODQxNjVmZmJlY2VjNmYyYzJiZGY4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjkgQXByIDIwMjEgMDA6MTg6NDMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBhZGQgc2h1dGRvd24gc3VwcG9ydAoKVmFyaW91cyBmaWxlc3lzdGVtIHN1cHBvcnQgdGhl
IHNodXRkb3duIGlvY3RsIHdoaWNoIGlzIHVzZWQgYnkgdmFyaW91cwp4ZnN0ZXN0cy4gVGhlIHNo
dXRkb3duIGlvY3RsIHNldHMgYSBmbGFnIG9uIHRoZSBzdXBlcmJsb2NrIHdoaWNoCnByZXZlbnRz
IG9wZW4sIHVubGluaywgc3ltbGluaywgaGFyZGxpbmssIHJtZGlyLCBjcmVhdGUgZXRjLgpvbiB0
aGUgZmlsZSBzeXN0ZW0gdW50aWwgdW5tb3VudCBhbmQgcmVtb3VudGVkLiBUaGUgdHdvIGZsYWdz
IHN1cHBvcnRlZAppbiB0aGlzIHBhdGNoIGFyZToKCiAgRlNPUF9HT0lOR19GTEFHU19MT0dGTFVT
SCBhbmQgRlNPUF9HT0lOR19GTEFHU19OT0xPR0ZMVVNICgp3aGljaCByZXF1aXJlIHZlcnkgbGl0
dGxlIG90aGVyIHRoYW4gYmxvY2tpbmcgbmV3IG9wZXJhdGlvbnMgKHNpbmNlCndlIGRvIG5vdCBj
YWNoZSB3cml0ZXMgdG8gbWV0YWRhdGEgb24gdGhlIGNsaWVudCB3aXRoIGNpZnMua28pLgpGU09Q
X0dPSU5HX0ZMQUdTX0RFRkFVTFQgaXMgbm90IHN1cHBvcnRlZCB5ZXQsIGJ1dCBjb3VsZCBiZSBh
ZGRlZCBpbgp0aGUgZnV0dXJlIGJ1dCB3b3VsZCBuZWVkIHRvIGNhbGwgc3luY2ZzIG9yIGVxdWl2
YWxlbnQgdG8gd3JpdGUgb3V0CnBlbmRpbmcgZGF0YSBvbiB0aGUgbW91bnQuCgpXaXRoIHRoaXMg
cGF0Y2ggdmFyaW91cyB4ZnN0ZXN0cyBub3cgd29yayBpbmNsdWRpbmcgdGVzdHMgMDQzIHRocm91
Z2gKMDQ2IGZvciBleGFtcGxlLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5j
aEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc19mc19zYi5oIHwgIDEgKwogZnMvY2lm
cy9jaWZzX2lvY3RsLmggfCAxNiArKysrKysrKysrKysrCiBmcy9jaWZzL2Rpci5jICAgICAgICB8
IDEwICsrKysrKysrKwogZnMvY2lmcy9maWxlLmMgICAgICAgfCAgNiArKysrKwogZnMvY2lmcy9m
c19jb250ZXh0LmMgfCAgMSArCiBmcy9jaWZzL2lub2RlLmMgICAgICB8IDI1ICsrKysrKysrKysr
KysrKysrKystLQogZnMvY2lmcy9pb2N0bC5jICAgICAgfCA1MyArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKwogZnMvY2lmcy9saW5rLmMgICAgICAgfCAgNyArKysr
KysKIGZzL2NpZnMveGF0dHIuYyAgICAgIHwgIDQgKysrKwogOSBmaWxlcyBjaGFuZ2VkLCAxMjEg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNf
ZnNfc2IuaCBiL2ZzL2NpZnMvY2lmc19mc19zYi5oCmluZGV4IDJhNTMyNWE3YWU0OS4uOWM0NWIz
YTgyYWQ5IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNfZnNfc2IuaAorKysgYi9mcy9jaWZzL2Np
ZnNfZnNfc2IuaApAQCAtNTUsNiArNTUsNyBAQAogI2RlZmluZSBDSUZTX01PVU5UX01PREVfRlJP
TV9TSUQgMHgxMDAwMDAwMCAvKiByZXRyaWV2ZSBtb2RlIGZyb20gc3BlY2lhbCBBQ0UgKi8KICNk
ZWZpbmUgQ0lGU19NT1VOVF9ST19DQUNIRQkweDIwMDAwMDAwICAvKiBhc3N1bWVzIHNoYXJlIHdp
bGwgbm90IGNoYW5nZSAqLwogI2RlZmluZSBDSUZTX01PVU5UX1JXX0NBQ0hFCTB4NDAwMDAwMDAg
IC8qIGFzc3VtZXMgb25seSBjbGllbnQgYWNjZXNzaW5nICovCisjZGVmaW5lIENJRlNfTU9VTlRf
U0hVVERPV04JMHg4MDAwMDAwMAogCiBzdHJ1Y3QgY2lmc19zYl9pbmZvIHsKIAlzdHJ1Y3QgcmJf
cm9vdCB0bGlua190cmVlOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzX2lvY3RsLmggYi9mcy9j
aWZzL2NpZnNfaW9jdGwuaAppbmRleCAxNTNkNWM4NDJhOWIuLmYyNjJjNjQ1MTZiYyAxMDA2NDQK
LS0tIGEvZnMvY2lmcy9jaWZzX2lvY3RsLmgKKysrIGIvZnMvY2lmcy9jaWZzX2lvY3RsLmgKQEAg
LTc4LDMgKzc4LDE5IEBAIHN0cnVjdCBzbWIzX25vdGlmeSB7CiAjZGVmaW5lIENJRlNfUVVFUllf
SU5GTyBfSU9XUihDSUZTX0lPQ1RMX01BR0lDLCA3LCBzdHJ1Y3Qgc21iX3F1ZXJ5X2luZm8pCiAj
ZGVmaW5lIENJRlNfRFVNUF9LRVkgX0lPV1IoQ0lGU19JT0NUTF9NQUdJQywgOCwgc3RydWN0IHNt
YjNfa2V5X2RlYnVnX2luZm8pCiAjZGVmaW5lIENJRlNfSU9DX05PVElGWSBfSU9XKENJRlNfSU9D
VExfTUFHSUMsIDksIHN0cnVjdCBzbWIzX25vdGlmeSkKKyNkZWZpbmUgQ0lGU19JT0NfU0hVVERP
V04gX0lPUiAoJ1gnLCAxMjUsIF9fdTMyKQorCisvKgorICogRmxhZ3MgZm9yIGdvaW5nIGRvd24g
b3BlcmF0aW9uCisgKi8KKyNkZWZpbmUgQ0lGU19HT0lOR19GTEFHU19ERUZBVUxUICAgICAgICAg
ICAgICAgIDB4MCAgICAgLyogZ29pbmcgZG93biAqLworI2RlZmluZSBDSUZTX0dPSU5HX0ZMQUdT
X0xPR0ZMVVNIICAgICAgICAgICAgICAgMHgxICAgICAvKiBmbHVzaCBsb2cgYnV0IG5vdCBkYXRh
ICovCisjZGVmaW5lIENJRlNfR09JTkdfRkxBR1NfTk9MT0dGTFVTSCAgICAgICAgICAgICAweDIg
ICAgIC8qIGRvbid0IGZsdXNoIGxvZyBub3IgZGF0YSAqLworCitzdGF0aWMgaW5saW5lIGJvb2wg
Y2lmc19mb3JjZWRfc2h1dGRvd24oc3RydWN0IGNpZnNfc2JfaW5mbyAqc2JpKQoreworCWlmIChD
SUZTX01PVU5UX1NIVVRET1dOICYgc2JpLT5tbnRfY2lmc19mbGFncykKKwkJcmV0dXJuIHRydWU7
CisJZWxzZQorCQlyZXR1cm4gZmFsc2U7Cit9CmRpZmYgLS1naXQgYS9mcy9jaWZzL2Rpci5jIGIv
ZnMvY2lmcy9kaXIuYwppbmRleCAwM2FmYWQ4YjI0YWYuLjI2MzcyMDEzMTk4NiAxMDA2NDQKLS0t
IGEvZnMvY2lmcy9kaXIuYworKysgYi9mcy9jaWZzL2Rpci5jCkBAIC0zNCw2ICszNCw3IEBACiAj
aW5jbHVkZSAiY2lmc19mc19zYi5oIgogI2luY2x1ZGUgImNpZnNfdW5pY29kZS5oIgogI2luY2x1
ZGUgImZzX2NvbnRleHQuaCIKKyNpbmNsdWRlICJjaWZzX2lvY3RsLmgiCiAKIHN0YXRpYyB2b2lk
CiByZW5ld19wYXJlbnRhbF90aW1lc3RhbXBzKHN0cnVjdCBkZW50cnkgKmRpcmVudHJ5KQpAQCAt
NDI5LDYgKzQzMCw5IEBAIGNpZnNfYXRvbWljX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3Ry
dWN0IGRlbnRyeSAqZGlyZW50cnksCiAJX191MzIgb3Bsb2NrOwogCXN0cnVjdCBjaWZzRmlsZUlu
Zm8gKmZpbGVfaW5mbzsKIAorCWlmICh1bmxpa2VseShjaWZzX2ZvcmNlZF9zaHV0ZG93bihDSUZT
X1NCKGlub2RlLT5pX3NiKSkpKQorCQlyZXR1cm4gLUVJTzsKKwogCS8qCiAJICogUG9zaXggb3Bl
biBpcyBvbmx5IGNhbGxlZCAoYXQgbG9va3VwIHRpbWUpIGZvciBmaWxlIGNyZWF0ZSBub3cuIEZv
cgogCSAqIG9wZW5zIChyYXRoZXIgdGhhbiBjcmVhdGVzKSwgYmVjYXVzZSB3ZSBkbyBub3Qga25v
dyBpZiBpdCBpcyBhIGZpbGUKQEAgLTU0NSw2ICs1NDksOSBAQCBpbnQgY2lmc19jcmVhdGUoc3Ry
dWN0IHVzZXJfbmFtZXNwYWNlICptbnRfdXNlcm5zLCBzdHJ1Y3QgaW5vZGUgKmlub2RlLAogCWNp
ZnNfZGJnKEZZSSwgImNpZnNfY3JlYXRlIHBhcmVudCBpbm9kZSA9IDB4JXAgbmFtZSBpczogJXBk
IGFuZCBkZW50cnkgPSAweCVwXG4iLAogCQkgaW5vZGUsIGRpcmVudHJ5LCBkaXJlbnRyeSk7CiAK
KwlpZiAodW5saWtlbHkoY2lmc19mb3JjZWRfc2h1dGRvd24oQ0lGU19TQihpbm9kZS0+aV9zYikp
KSkKKwkJcmV0dXJuIC1FSU87CisKIAl0bGluayA9IGNpZnNfc2JfdGxpbmsoQ0lGU19TQihpbm9k
ZS0+aV9zYikpOwogCXJjID0gUFRSX0VSUih0bGluayk7CiAJaWYgKElTX0VSUih0bGluaykpCkBA
IC01ODIsNiArNTg5LDkgQEAgaW50IGNpZnNfbWtub2Qoc3RydWN0IHVzZXJfbmFtZXNwYWNlICpt
bnRfdXNlcm5zLCBzdHJ1Y3QgaW5vZGUgKmlub2RlLAogCQlyZXR1cm4gLUVJTlZBTDsKIAogCWNp
ZnNfc2IgPSBDSUZTX1NCKGlub2RlLT5pX3NiKTsKKwlpZiAodW5saWtlbHkoY2lmc19mb3JjZWRf
c2h1dGRvd24oY2lmc19zYikpKQorCQlyZXR1cm4gLUVJTzsKKwogCXRsaW5rID0gY2lmc19zYl90
bGluayhjaWZzX3NiKTsKIAlpZiAoSVNfRVJSKHRsaW5rKSkKIAkJcmV0dXJuIFBUUl9FUlIodGxp
bmspOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwppbmRleCA1
MDU4MjUyZWVhZTYuLjkxOWM4MmQ0NzEzZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMKKysr
IGIvZnMvY2lmcy9maWxlLmMKQEAgLTQ1LDYgKzQ1LDcgQEAKICNpbmNsdWRlICJmc2NhY2hlLmgi
CiAjaW5jbHVkZSAic21iZGlyZWN0LmgiCiAjaW5jbHVkZSAiZnNfY29udGV4dC5oIgorI2luY2x1
ZGUgImNpZnNfaW9jdGwuaCIKIAogc3RhdGljIGlubGluZSBpbnQgY2lmc19jb252ZXJ0X2ZsYWdz
KHVuc2lnbmVkIGludCBmbGFncykKIHsKQEAgLTU0Miw2ICs1NDMsMTEgQEAgaW50IGNpZnNfb3Bl
bihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIAl4aWQgPSBnZXRfeGlk
KCk7CiAKIAljaWZzX3NiID0gQ0lGU19TQihpbm9kZS0+aV9zYik7CisJaWYgKHVubGlrZWx5KGNp
ZnNfZm9yY2VkX3NodXRkb3duKGNpZnNfc2IpKSkgeworCQlmcmVlX3hpZCh4aWQpOworCQlyZXR1
cm4gLUVJTzsKKwl9CisKIAl0bGluayA9IGNpZnNfc2JfdGxpbmsoY2lmc19zYik7CiAJaWYgKElT
X0VSUih0bGluaykpIHsKIAkJZnJlZV94aWQoeGlkKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZnNf
Y29udGV4dC5jIGIvZnMvY2lmcy9mc19jb250ZXh0LmMKaW5kZXggM2UwZDAxNjg0OWUzLi4xZDZl
MGUxNWIwMzQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZnNfY29udGV4dC5jCisrKyBiL2ZzL2NpZnMv
ZnNfY29udGV4dC5jCkBAIC0xNjQyLDYgKzE2NDIsNyBAQCB2b2lkIHNtYjNfdXBkYXRlX21udF9m
bGFncyhzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiKQogCQkJY2lmc19kYmcoVkZTLCAibW91
bnQgb3B0aW9ucyBtZnN5bWxpbmtzIGFuZCBzZnUgYm90aCBlbmFibGVkXG4iKTsKIAkJfQogCX0K
KwljaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmPSB+Q0lGU19NT1VOVF9TSFVURE9XTjsKIAogCXJl
dHVybjsKIH0KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvaW5vZGUuYyBiL2ZzL2NpZnMvaW5vZGUuYwpp
bmRleCBiYWE5ZmZiNGM0NDYuLjU5MWYxOGUzZTkzMyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9pbm9k
ZS5jCisrKyBiL2ZzL2NpZnMvaW5vZGUuYwpAQCAtMjYsNyArMjYsNiBAQAogI2luY2x1ZGUgPGxp
bnV4L3NjaGVkL3NpZ25hbC5oPgogI2luY2x1ZGUgPGxpbnV4L3dhaXRfYml0Lmg+CiAjaW5jbHVk
ZSA8bGludXgvZmllbWFwLmg+Ci0KICNpbmNsdWRlIDxhc20vZGl2NjQuaD4KICNpbmNsdWRlICJj
aWZzZnMuaCIKICNpbmNsdWRlICJjaWZzcGR1LmgiCkBAIC0zOCw3ICszNyw3IEBACiAjaW5jbHVk
ZSAiY2lmc191bmljb2RlLmgiCiAjaW5jbHVkZSAiZnNjYWNoZS5oIgogI2luY2x1ZGUgImZzX2Nv
bnRleHQuaCIKLQorI2luY2x1ZGUgImNpZnNfaW9jdGwuaCIKIAogc3RhdGljIHZvaWQgY2lmc19z
ZXRfb3BzKHN0cnVjdCBpbm9kZSAqaW5vZGUpCiB7CkBAIC0xNjIzLDYgKzE2MjIsOSBAQCBpbnQg
Y2lmc191bmxpbmsoc3RydWN0IGlub2RlICpkaXIsIHN0cnVjdCBkZW50cnkgKmRlbnRyeSkKIAog
CWNpZnNfZGJnKEZZSSwgImNpZnNfdW5saW5rLCBkaXI9MHglcCwgZGVudHJ5PTB4JXBcbiIsIGRp
ciwgZGVudHJ5KTsKIAorCWlmICh1bmxpa2VseShjaWZzX2ZvcmNlZF9zaHV0ZG93bihjaWZzX3Ni
KSkpCisJCXJldHVybiAtRUlPOworCiAJdGxpbmsgPSBjaWZzX3NiX3RsaW5rKGNpZnNfc2IpOwog
CWlmIChJU19FUlIodGxpbmspKQogCQlyZXR1cm4gUFRSX0VSUih0bGluayk7CkBAIC0xODc2LDYg
KzE4NzgsOCBAQCBpbnQgY2lmc19ta2RpcihzdHJ1Y3QgdXNlcl9uYW1lc3BhY2UgKm1udF91c2Vy
bnMsIHN0cnVjdCBpbm9kZSAqaW5vZGUsCiAJCSBtb2RlLCBpbm9kZSk7CiAKIAljaWZzX3NiID0g
Q0lGU19TQihpbm9kZS0+aV9zYik7CisJaWYgKHVubGlrZWx5KGNpZnNfZm9yY2VkX3NodXRkb3du
KGNpZnNfc2IpKSkKKwkJcmV0dXJuIC1FSU87CiAJdGxpbmsgPSBjaWZzX3NiX3RsaW5rKGNpZnNf
c2IpOwogCWlmIChJU19FUlIodGxpbmspKQogCQlyZXR1cm4gUFRSX0VSUih0bGluayk7CkBAIC0x
OTU4LDYgKzE5NjIsMTEgQEAgaW50IGNpZnNfcm1kaXIoc3RydWN0IGlub2RlICppbm9kZSwgc3Ry
dWN0IGRlbnRyeSAqZGlyZW50cnkpCiAJfQogCiAJY2lmc19zYiA9IENJRlNfU0IoaW5vZGUtPmlf
c2IpOworCWlmICh1bmxpa2VseShjaWZzX2ZvcmNlZF9zaHV0ZG93bihjaWZzX3NiKSkpIHsKKwkJ
cmMgPSAtRUlPOworCQlnb3RvIHJtZGlyX2V4aXQ7CisJfQorCiAJdGxpbmsgPSBjaWZzX3NiX3Rs
aW5rKGNpZnNfc2IpOwogCWlmIChJU19FUlIodGxpbmspKSB7CiAJCXJjID0gUFRSX0VSUih0bGlu
ayk7CkBAIC0yMDkyLDYgKzIxMDEsOSBAQCBjaWZzX3JlbmFtZTIoc3RydWN0IHVzZXJfbmFtZXNw
YWNlICptbnRfdXNlcm5zLCBzdHJ1Y3QgaW5vZGUgKnNvdXJjZV9kaXIsCiAJCXJldHVybiAtRUlO
VkFMOwogCiAJY2lmc19zYiA9IENJRlNfU0Ioc291cmNlX2Rpci0+aV9zYik7CisJaWYgKHVubGlr
ZWx5KGNpZnNfZm9yY2VkX3NodXRkb3duKGNpZnNfc2IpKSkKKwkJcmV0dXJuIC1FSU87CisKIAl0
bGluayA9IGNpZnNfc2JfdGxpbmsoY2lmc19zYik7CiAJaWYgKElTX0VSUih0bGluaykpCiAJCXJl
dHVybiBQVFJfRVJSKHRsaW5rKTsKQEAgLTI0MDksNiArMjQyMSw5IEBAIGludCBjaWZzX2dldGF0
dHIoc3RydWN0IHVzZXJfbmFtZXNwYWNlICptbnRfdXNlcm5zLCBjb25zdCBzdHJ1Y3QgcGF0aCAq
cGF0aCwKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gZF9pbm9kZShkZW50cnkpOwogCWludCByYzsK
IAorCWlmICh1bmxpa2VseShjaWZzX2ZvcmNlZF9zaHV0ZG93bihDSUZTX1NCKGlub2RlLT5pX3Ni
KSkpKQorCQlyZXR1cm4gLUVJTzsKKwogCS8qCiAJICogV2UgbmVlZCB0byBiZSBzdXJlIHRoYXQg
YWxsIGRpcnR5IHBhZ2VzIGFyZSB3cml0dGVuIGFuZCB0aGUgc2VydmVyCiAJICogaGFzIGFjdHVh
bCBjdGltZSwgbXRpbWUgYW5kIGZpbGUgbGVuZ3RoLgpAQCAtMjQ4MSw2ICsyNDk2LDkgQEAgaW50
IGNpZnNfZmllbWFwKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWVtYXBfZXh0ZW50X2lu
Zm8gKmZlaSwgdTY0IHN0YXJ0LAogCXN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlOwogCWludCBy
YzsKIAorCWlmICh1bmxpa2VseShjaWZzX2ZvcmNlZF9zaHV0ZG93bihjaWZzX3NiKSkpCisJCXJl
dHVybiAtRUlPOworCiAJLyoKIAkgKiBXZSBuZWVkIHRvIGJlIHN1cmUgdGhhdCBhbGwgZGlydHkg
cGFnZXMgYXJlIHdyaXR0ZW4gYXMgdGhleQogCSAqIG1pZ2h0IGZpbGwgaG9sZXMgb24gdGhlIHNl
cnZlci4KQEAgLTI5NjcsNiArMjk4NSw5IEBAIGNpZnNfc2V0YXR0cihzdHJ1Y3QgdXNlcl9uYW1l
c3BhY2UgKm1udF91c2VybnMsIHN0cnVjdCBkZW50cnkgKmRpcmVudHJ5LAogCXN0cnVjdCBjaWZz
X3Rjb24gKnBUY29uID0gY2lmc19zYl9tYXN0ZXJfdGNvbihjaWZzX3NiKTsKIAlpbnQgcmMsIHJl
dHJpZXMgPSAwOwogCisJaWYgKHVubGlrZWx5KGNpZnNfZm9yY2VkX3NodXRkb3duKGNpZnNfc2Ip
KSkKKwkJcmV0dXJuIC1FSU87CisKIAlkbyB7CiAJCWlmIChwVGNvbi0+dW5peF9leHQpCiAJCQly
YyA9IGNpZnNfc2V0YXR0cl91bml4KGRpcmVudHJ5LCBhdHRycyk7CmRpZmYgLS1naXQgYS9mcy9j
aWZzL2lvY3RsLmMgYi9mcy9jaWZzL2lvY3RsLmMKaW5kZXggMDhkOTlmZWM1OTNlLi5lZjQxZmE4
Nzg3OTMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvaW9jdGwuYworKysgYi9mcy9jaWZzL2lvY3RsLmMK
QEAgLTE2NCw2ICsxNjQsNTYgQEAgc3RhdGljIGxvbmcgc21iX21udF9nZXRfZnNpbmZvKHVuc2ln
bmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJcmV0dXJuIHJjOwogfQogCitz
dGF0aWMgaW50IGNpZnNfc2h1dGRvd24oc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgdW5zaWduZWQg
bG9uZyBhcmcpCit7CisJc3RydWN0IGNpZnNfc2JfaW5mbyAqc2JpID0gQ0lGU19TQihzYik7CisJ
X191MzIgZmxhZ3M7CisKKwlpZiAoIWNhcGFibGUoQ0FQX1NZU19BRE1JTikpCisJCXJldHVybiAt
RVBFUk07CisKKwlpZiAoZ2V0X3VzZXIoZmxhZ3MsIChfX3UzMiBfX3VzZXIgKilhcmcpKQorCQly
ZXR1cm4gLUVGQVVMVDsKKworCWlmIChmbGFncyA+IENJRlNfR09JTkdfRkxBR1NfTk9MT0dGTFVT
SCkKKwkJcmV0dXJuIC1FSU5WQUw7CisKKwlpZiAoY2lmc19mb3JjZWRfc2h1dGRvd24oc2JpKSkK
KwkJcmV0dXJuIDA7CisKKwljaWZzX2RiZyhWRlMsICJzaHV0IGRvd24gcmVxdWVzdGVkICglZCki
LCBmbGFncyk7CisvKgl0cmFjZV9jaWZzX3NodXRkb3duKHNiLCBmbGFncyk7Ki8KKworCS8qCisJ
ICogc2VlOgorCSAqICAgaHR0cHM6Ly9tYW43Lm9yZy9saW51eC9tYW4tcGFnZXMvbWFuMi9pb2N0
bF94ZnNfZ29pbmdkb3duLjIuaHRtbAorCSAqIGZvciBtb3JlIGluZm9ybWF0aW9uIGFuZCBkZXNj
cmlwdGlvbiBvZiBvcmlnaW5hbCBpbnRlbnQgb2YgdGhlIGZsYWdzCisJICovCisJc3dpdGNoIChm
bGFncykgeworCS8qCisJICogV2UgY291bGQgYWRkIHN1cHBvcnQgbGF0ZXIgZm9yIGRlZmF1bHQg
ZmxhZyB3aGljaCByZXF1aXJlczoKKwkgKiAgICAgIkZsdXNoIGFsbCBkaXJ0eSBkYXRhIGFuZCBt
ZXRhZGF0YSB0byBkaXNrIgorCSAqIHdvdWxkIG5lZWQgdG8gY2FsbCBzeW5jZnMgb3IgZXF1aXZh
bGVudCB0byBmbHVzaCBwYWdlIGNhY2hlIGZvcgorCSAqIHRoZSBtb3VudCBhbmQgdGhlbiBpc3N1
ZSBmc3luYyB0byBzZXJ2ZXIgKGlmIG5vc3RyaWN0c3luYyBub3Qgc2V0KQorCSAqLworCWNhc2Ug
Q0lGU19HT0lOR19GTEFHU19ERUZBVUxUOgorCQljaWZzX2RiZyhGWUksICJzaHV0ZG93biB3aXRo
IGRlZmF1bHQgZmxhZyBub3Qgc3VwcG9ydGVkXG4iKTsKKwkJcmV0dXJuIC1FSU5WQUw7CisJLyoK
KwkgKiBGTEFHU19MT0dGTFVTSCBpcyBlYXN5IHNpbmNlIGl0IGFza3MgdG8gd3JpdGUgb3V0IG1l
dGFkYXRhIChub3QKKwkgKiBkYXRhKSBidXQgbWV0YWRhdGEgd3JpdGVzIGFyZSBub3QgY2FjaGVk
IG9uIHRoZSBjbGllbnQsIHNvIGNhbiB0cmVhdAorCSAqIGl0IHNpbWlsYXJseSB0byBOT0xPR0ZM
VVNICisJICovCisJY2FzZSBDSUZTX0dPSU5HX0ZMQUdTX0xPR0ZMVVNIOgorCWNhc2UgQ0lGU19H
T0lOR19GTEFHU19OT0xPR0ZMVVNIOgorCQlzYmktPm1udF9jaWZzX2ZsYWdzIHw9IENJRlNfTU9V
TlRfU0hVVERPV047CisJCXJldHVybiAwOworCWRlZmF1bHQ6CisJCXJldHVybiAtRUlOVkFMOwor
CX0KKwlyZXR1cm4gMDsKK30KKwogbG9uZyBjaWZzX2lvY3RsKHN0cnVjdCBmaWxlICpmaWxlcCwg
dW5zaWduZWQgaW50IGNvbW1hbmQsIHVuc2lnbmVkIGxvbmcgYXJnKQogewogCXN0cnVjdCBpbm9k
ZSAqaW5vZGUgPSBmaWxlX2lub2RlKGZpbGVwKTsKQEAgLTMyNSw2ICszNzUsOSBAQCBsb25nIGNp
ZnNfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGVwLCB1bnNpZ25lZCBpbnQgY29tbWFuZCwgdW5zaWdu
ZWQgbG9uZyBhcmcpCiAJCQkJcmMgPSAtRU9QTk9UU1VQUDsKIAkJCWNpZnNfcHV0X3RsaW5rKHRs
aW5rKTsKIAkJCWJyZWFrOworCQljYXNlIENJRlNfSU9DX1NIVVRET1dOOgorCQkJcmMgPSBjaWZz
X3NodXRkb3duKGlub2RlLT5pX3NiLCBhcmcpOworCQkJYnJlYWs7CiAJCWRlZmF1bHQ6CiAJCQlj
aWZzX2RiZyhGWUksICJ1bnN1cHBvcnRlZCBpb2N0bFxuIik7CiAJCQlicmVhazsKZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvbGluay5jIGIvZnMvY2lmcy9saW5rLmMKaW5kZXggNjE2ZTFiYzBjYzBhLi4x
Y2JlN2VjNzM3MjggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvbGluay5jCisrKyBiL2ZzL2NpZnMvbGlu
ay5jCkBAIC0zMCw2ICszMCw3IEBACiAjaW5jbHVkZSAiY2lmc19mc19zYi5oIgogI2luY2x1ZGUg
ImNpZnNfdW5pY29kZS5oIgogI2luY2x1ZGUgInNtYjJwcm90by5oIgorI2luY2x1ZGUgImNpZnNf
aW9jdGwuaCIKIAogLyoKICAqIE0tRiBTeW1saW5rIEZ1bmN0aW9ucyAtIEJlZ2luCkBAIC01MTgs
NiArNTE5LDkgQEAgY2lmc19oYXJkbGluayhzdHJ1Y3QgZGVudHJ5ICpvbGRfZmlsZSwgc3RydWN0
IGlub2RlICppbm9kZSwKIAlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXI7CiAJc3RydWN0
IGNpZnNJbm9kZUluZm8gKmNpZnNJbm9kZTsKIAorCWlmICh1bmxpa2VseShjaWZzX2ZvcmNlZF9z
aHV0ZG93bihjaWZzX3NiKSkpCisJCXJldHVybiAtRUlPOworCiAJdGxpbmsgPSBjaWZzX3NiX3Rs
aW5rKGNpZnNfc2IpOwogCWlmIChJU19FUlIodGxpbmspKQogCQlyZXR1cm4gUFRSX0VSUih0bGlu
ayk7CkBAIC02ODIsNiArNjg2LDkgQEAgY2lmc19zeW1saW5rKHN0cnVjdCB1c2VyX25hbWVzcGFj
ZSAqbW50X3VzZXJucywgc3RydWN0IGlub2RlICppbm9kZSwKIAl2b2lkICpwYWdlID0gYWxsb2Nf
ZGVudHJ5X3BhdGgoKTsKIAlzdHJ1Y3QgaW5vZGUgKm5ld2lub2RlID0gTlVMTDsKIAorCWlmICh1
bmxpa2VseShjaWZzX2ZvcmNlZF9zaHV0ZG93bihjaWZzX3NiKSkpCisJCXJldHVybiAtRUlPOwor
CiAJeGlkID0gZ2V0X3hpZCgpOwogCiAJdGxpbmsgPSBjaWZzX3NiX3RsaW5rKGNpZnNfc2IpOwpk
aWZmIC0tZ2l0IGEvZnMvY2lmcy94YXR0ci5jIGIvZnMvY2lmcy94YXR0ci5jCmluZGV4IGUzNTFi
OTQ1MTM1Yi4uYWEzZThjYTA0NTdjIDEwMDY0NAotLS0gYS9mcy9jaWZzL3hhdHRyLmMKKysrIGIv
ZnMvY2lmcy94YXR0ci5jCkBAIC0zMCw2ICszMCw3IEBACiAjaW5jbHVkZSAiY2lmc19kZWJ1Zy5o
IgogI2luY2x1ZGUgImNpZnNfZnNfc2IuaCIKICNpbmNsdWRlICJjaWZzX3VuaWNvZGUuaCIKKyNp
bmNsdWRlICJjaWZzX2lvY3RsLmgiCiAKICNkZWZpbmUgTUFYX0VBX1ZBTFVFX1NJWkUgQ0lGU01h
eEJ1ZlNpemUKICNkZWZpbmUgQ0lGU19YQVRUUl9DSUZTX0FDTCAic3lzdGVtLmNpZnNfYWNsIiAv
KiBEQUNMIG9ubHkgKi8KQEAgLTQyMSw2ICs0MjIsOSBAQCBzc2l6ZV90IGNpZnNfbGlzdHhhdHRy
KHN0cnVjdCBkZW50cnkgKmRpcmVudHJ5LCBjaGFyICpkYXRhLCBzaXplX3QgYnVmX3NpemUpCiAJ
Y29uc3QgY2hhciAqZnVsbF9wYXRoOwogCXZvaWQgKnBhZ2U7CiAKKwlpZiAodW5saWtlbHkoY2lm
c19mb3JjZWRfc2h1dGRvd24oY2lmc19zYikpKQorCQlyZXR1cm4gLUVJTzsKKwogCWlmIChjaWZz
X3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfTk9fWEFUVFIpCiAJCXJldHVybiAtRU9Q
Tk9UU1VQUDsKIAotLSAKMi4yNy4wCgo=
--000000000000d7470705c12566cb--
