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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33546C4361B
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Dec 2020 22:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0192323C83
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Dec 2020 22:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732756AbgLKVtg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Dec 2020 16:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389212AbgLKVtY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Dec 2020 16:49:24 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFA9C0613D3
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 13:48:43 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id y19so15279688lfa.13
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 13:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tQfzHXiIJ20KpmREOlr4byoXshJ1MrKLua4lgjQ/C4s=;
        b=B4QeKxbgbk/38h4/6A/7RL2Hi3rUOcM2UGFVRI8hYBPJGiqx7WGPoLKhwD8ww7C5B4
         96klys3h8fFNQ0vc7eapIU/B/NcDgBHWdPj0nYUtDyUWlyDPIL++0Ev3A2KcAeuVwRVA
         CF/5IZ/IjCMH9VcZ3NT5vEbskKrsh3YlScD9gw0QpI0+HDpWjraky8ElVfzxSbKqrKI8
         AZzdVaxevBbk7WBkEhp+VQugkvK1laM4jtiy3AMItsj6NQX4I0T92fMd7vdr9FuozaJm
         7tPbEmqcBZLblSyYI7txJ+GdKe7eupRAwhP5Ey4n4otyZrTjCYgFjskJyuCgVeg9/EaV
         Hnjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tQfzHXiIJ20KpmREOlr4byoXshJ1MrKLua4lgjQ/C4s=;
        b=Kagl68h+LF3TAfM1o5P805osX3rw1I4w8j0+p10I1gO2qoMYMmdpsG2Qufh1ulooyH
         sXvQ9kWgOvw4P/c/A+dSFD1Dr2WaRma4DLSDkL503RI2+Y4tzJQVQgbIMIyInMin8GiN
         t7ZrNm7vYI9oBKVo43b7qfXjBWIBNsFpFPwgH5fgN6Tcy6I0jd44fXLE51k+saksVm9m
         cldmvdQI9EQLV5GMAOo0MnHpSj4fJ0EspnZ6z7cIqHc3tYrlCUvxJY1lvb6/kbma4bIl
         64qls3sEaU7h+DmCYgkyZfI7VOvMGXY5axjXVjBFse+3CSIuPSTdhmWxqrj8thT8H84t
         qngg==
X-Gm-Message-State: AOAM531p+UzeadG6BM/ucAcYN3qP+617yp0qtIgLYlx/NyxTjDxXwn+W
        qFxw5y8EExCZTs9NZTFnDPhU81C9Yary2inJP+A=
X-Google-Smtp-Source: ABdhPJyMJviTJr/hL36qxGvj18QCNHC4a0KUVV4eRS4v9Euq3Oxcp/jS18DMRkzfMK9YFAYlpWex1hJ5CE+1CdrNxAM=
X-Received: by 2002:a19:950:: with SMTP id 77mr5010683lfj.133.1607723321872;
 Fri, 11 Dec 2020 13:48:41 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mvr6JebH9cr9dO-XbiXdsfBjs=C4WhqkqXUwDCmOY20zA@mail.gmail.com>
 <CAKywueTTZkpnYDba_S4yRJ6UheU6f7fefA3XMoicG7RvmtfzOw@mail.gmail.com> <CAKywueTjoTYLvswymsNNdaezFtGP0+Zqj3GNJV=Sz+pYfytjGA@mail.gmail.com>
In-Reply-To: <CAKywueTjoTYLvswymsNNdaezFtGP0+Zqj3GNJV=Sz+pYfytjGA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 11 Dec 2020 15:48:30 -0600
Message-ID: <CAH2r5mtY3JjvpXs_xutj4jVjO3QO5mofjkZJqLWaXy=vMBZ_6w@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] remove confusing mount warning when no SPNEGO
 info on negprot rsp
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000007f6f5e05b63741c8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007f6f5e05b63741c8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated patch with Pavel's suggestion


On Fri, Dec 11, 2020 at 12:37 PM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>
> =D1=87=D1=82, 10 =D0=B4=D0=B5=D0=BA. 2020 =D0=B3. =D0=B2 09:45, Pavel Shi=
lovsky <piastryyy@gmail.com>:
> >
> > =D0=B2=D1=82, 8 =D0=B4=D0=B5=D0=BA. 2020 =D0=B3. =D0=B2 23:23, Steve Fr=
ench <smfrench@gmail.com>:
> > >
> > > Azure does not send an SPNEGO blob in the negotiate protocol response=
,
> > > so we shouldn't assume that it is there when validating the location
> > > of the first negotiate context.  This avoids the potential confusing
> > > mount warning:
> > >
> > >    CIFS: Invalid negotiate context offset
> > >
> > > CC: Stable <stable@vger.kernel.org>
> > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > ---
> > >  fs/cifs/smb2misc.c | 11 +++++++----
> > >  1 file changed, 7 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> > > index d88e2683626e..513507e4c4ad 100644
> > > --- a/fs/cifs/smb2misc.c
> > > +++ b/fs/cifs/smb2misc.c
> > > @@ -109,11 +109,14 @@ static __u32 get_neg_ctxt_len(struct
> > > smb2_sync_hdr *hdr, __u32 len,
> > >
> > >   /* Make sure that negotiate contexts start after gss security blob =
*/
> > >   nc_offset =3D le32_to_cpu(pneg_rsp->NegotiateContextOffset);
> > > - if (nc_offset < non_ctxlen) {
> > > - pr_warn_once("Invalid negotiate context offset\n");
> > > + if (nc_offset + 1 < non_ctxlen) {
> > > + pr_warn_once("Invalid negotiate context offset %d\n", nc_offset);
> > >   return 0;
> > > - }
> > > - size_of_pad_before_neg_ctxts =3D nc_offset - non_ctxlen;
> > > + } else if (nc_offset + 1 =3D=3D non_ctxlen) {
> > > + cifs_dbg(FYI, "no SPNEGO security blob in negprot rsp\n");
> > > + size_of_pad_before_neg_ctxts =3D 0;
> > > + } else
> > > + size_of_pad_before_neg_ctxts =3D nc_offset - non_ctxlen;
> > >
> >
> > This seems missing "+1" in the line above (non_ctxlen is 1 byte bigger
> > than the fix-sized area of the packet):
> > size_of_pad_before_neg_ctxts =3D nc_offset + 1 - non_ctxlen;
> >
>
> It seems that +1 would be needed if there is no SPNEGO security blob
> but negotiate context offset is padded for other reasons. In this case
> non_ctxlen will account for 1 byte from the padding. The only way here
> would be to do something like:
>
>  size_of_pad_before_neg_ctxts =3D nc_offset - non_ctxlen + (non_ctxlen
> =3D=3D 65 ? 1 : 0);
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve

--0000000000007f6f5e05b63741c8
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3.1.1-remove-confusing-mount-warning-when-no-SPNE.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3.1.1-remove-confusing-mount-warning-when-no-SPNE.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kiksxt8u0>
X-Attachment-Id: f_kiksxt8u0

RnJvbSBiMjRhNzQ0Yjk4Y2VjNTlkYjgwMDE4ZDFlZmU5MzczMDZhMmM4MWQxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgOSBEZWMgMjAyMCAwMToxMjozNSAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjMuMS4xOiByZW1vdmUgY29uZnVzaW5nIG1vdW50IHdhcm5pbmcgd2hlbiBubyBTUE5FR08gaW5m
bwogb24gbmVncHJvdCByc3AKCkF6dXJlIGRvZXMgbm90IHNlbmQgYW4gU1BORUdPIGJsb2IgaW4g
dGhlIG5lZ290aWF0ZSBwcm90b2NvbCByZXNwb25zZSwKc28gd2Ugc2hvdWxkbid0IGFzc3VtZSB0
aGF0IGl0IGlzIHRoZXJlIHdoZW4gdmFsaWRhdGluZyB0aGUgbG9jYXRpb24Kb2YgdGhlIGZpcnN0
IG5lZ290aWF0ZSBjb250ZXh0LiAgVGhpcyBhdm9pZHMgdGhlIHBvdGVudGlhbCBjb25mdXNpbmcK
bW91bnQgd2FybmluZzoKCiAgIENJRlM6IEludmFsaWQgbmVnb3RpYXRlIGNvbnRleHQgb2Zmc2V0
CgpDQzogU3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpSZXZpZXdlZC1ieTogUGF2ZWwg
U2hpbG92c2t5IDxwc2hpbG92QG1pY3Jvc29mdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZy
ZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJtaXNjLmMgfCAx
NiArKysrKysrKysrKystLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgNCBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJtaXNjLmMgYi9mcy9jaWZzL3Nt
YjJtaXNjLmMKaW5kZXggZDg4ZTI2ODM2MjZlLi4yZGE2YjQxY2I1NTIgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvc21iMm1pc2MuYworKysgYi9mcy9jaWZzL3NtYjJtaXNjLmMKQEAgLTk0LDYgKzk0LDgg
QEAgc3RhdGljIGNvbnN0IF9fbGUxNiBzbWIyX3JzcF9zdHJ1Y3Rfc2l6ZXNbTlVNQkVSX09GX1NN
QjJfQ09NTUFORFNdID0gewogCS8qIFNNQjJfT1BMT0NLX0JSRUFLICovIGNwdV90b19sZTE2KDI0
KQogfTsKIAorI2RlZmluZSBTTUIzMTFfTkVHUFJPVF9CQVNFX1NJWkUgKHNpemVvZihzdHJ1Y3Qg
c21iMl9zeW5jX2hkcikgKyBzaXplb2Yoc3RydWN0IHNtYjJfbmVnb3RpYXRlX3JzcCkpCisKIHN0
YXRpYyBfX3UzMiBnZXRfbmVnX2N0eHRfbGVuKHN0cnVjdCBzbWIyX3N5bmNfaGRyICpoZHIsIF9f
dTMyIGxlbiwKIAkJCSAgICAgIF9fdTMyIG5vbl9jdHhsZW4pCiB7CkBAIC0xMDksMTEgKzExMSwx
NyBAQCBzdGF0aWMgX191MzIgZ2V0X25lZ19jdHh0X2xlbihzdHJ1Y3Qgc21iMl9zeW5jX2hkciAq
aGRyLCBfX3UzMiBsZW4sCiAKIAkvKiBNYWtlIHN1cmUgdGhhdCBuZWdvdGlhdGUgY29udGV4dHMg
c3RhcnQgYWZ0ZXIgZ3NzIHNlY3VyaXR5IGJsb2IgKi8KIAluY19vZmZzZXQgPSBsZTMyX3RvX2Nw
dShwbmVnX3JzcC0+TmVnb3RpYXRlQ29udGV4dE9mZnNldCk7Ci0JaWYgKG5jX29mZnNldCA8IG5v
bl9jdHhsZW4pIHsKLQkJcHJfd2Fybl9vbmNlKCJJbnZhbGlkIG5lZ290aWF0ZSBjb250ZXh0IG9m
ZnNldFxuIik7CisJaWYgKG5jX29mZnNldCArIDEgPCBub25fY3R4bGVuKSB7CisJCXByX3dhcm5f
b25jZSgiSW52YWxpZCBuZWdvdGlhdGUgY29udGV4dCBvZmZzZXQgJWRcbiIsIG5jX29mZnNldCk7
CiAJCXJldHVybiAwOwotCX0KLQlzaXplX29mX3BhZF9iZWZvcmVfbmVnX2N0eHRzID0gbmNfb2Zm
c2V0IC0gbm9uX2N0eGxlbjsKKwl9IGVsc2UgaWYgKG5jX29mZnNldCArIDEgPT0gbm9uX2N0eGxl
bikgeworCQljaWZzX2RiZyhGWUksICJubyBTUE5FR08gc2VjdXJpdHkgYmxvYiBpbiBuZWdwcm90
IHJzcFxuIik7CisJCXNpemVfb2ZfcGFkX2JlZm9yZV9uZWdfY3R4dHMgPSAwOworCX0gZWxzZSBp
ZiAobm9uX2N0eGxlbiA9PSBTTUIzMTFfTkVHUFJPVF9CQVNFX1NJWkUpCisJCS8qIGhhcyBwYWRk
aW5nLCBidXQgbm8gU1BORUdPIGJsb2IgKi8KKwkJc2l6ZV9vZl9wYWRfYmVmb3JlX25lZ19jdHh0
cyA9IG5jX29mZnNldCAtIG5vbl9jdHhsZW4gKyAxOworCWVsc2UKKwkJc2l6ZV9vZl9wYWRfYmVm
b3JlX25lZ19jdHh0cyA9IG5jX29mZnNldCAtIG5vbl9jdHhsZW47CiAKIAkvKiBWZXJpZnkgdGhh
dCBhdCBsZWFzdCBtaW5pbWFsIG5lZ290aWF0ZSBjb250ZXh0cyBmaXQgd2l0aGluIGZyYW1lICov
CiAJaWYgKGxlbiA8IG5jX29mZnNldCArIChuZWdfY291bnQgKiBzaXplb2Yoc3RydWN0IHNtYjJf
bmVnX2NvbnRleHQpKSkgewotLSAKMi4yNy4wCgo=
--0000000000007f6f5e05b63741c8--
