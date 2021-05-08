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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD96C433ED
	for <linux-cifs@archiver.kernel.org>; Sat,  8 May 2021 15:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0000E6128A
	for <linux-cifs@archiver.kernel.org>; Sat,  8 May 2021 15:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhEHPLn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 May 2021 11:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhEHPLm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 8 May 2021 11:11:42 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138A6C061574
        for <linux-cifs@vger.kernel.org>; Sat,  8 May 2021 08:10:41 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id o16so15326386ljp.3
        for <linux-cifs@vger.kernel.org>; Sat, 08 May 2021 08:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hguV32LtVwfHHERdnGl/jcOlbqYgseJzYJyyDfRtVs0=;
        b=XTSCHCJBU/gSPfjBkMSQ6c3bFuV2Vin8wuVlZl8Tdvlb2TYnSXWGh2vnfkMVy5SwQa
         9ymx1elhDa+4Z5tALvle8Tr8gA52G11eUWG7vYOGzb8x3YXat5H75OoPfqlhmz5oeQiE
         odpZyq9qnXhC+eQrMxTlO7KGV0Z38ZIyQJfV6KcMyy5u4R8G3cXn1uTGroYlrGy4B/7I
         47AB3TmxQR6+1sIOj442ou2OqVP9wDgn4mu1nCWfO66K0UMu4I6NsIlUtmsio8m7JCYL
         2WMmvH6KrM6RV/6k7luMbmHvyfosw1jN/R0w7JZCcqyZNGxKTQV247d/MSyS9/dWJGq+
         TG8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hguV32LtVwfHHERdnGl/jcOlbqYgseJzYJyyDfRtVs0=;
        b=paGJLHHXaL2YcV1maoLxPaO0YzURCithezGQiTesXR+ZJLaxdvPe6PlBFS56HXVmz4
         GdhuHWiKDKeVu7/dl7VdgdewLqUza2HyO+OwSwdKk7YVmhHNcgAE4kwYyjcXds9ilzX0
         TBdS3avU2uB30paBVFjPr6OiWLX+jluRXBM1ua+M9XAm5Onn068K9JvSDzjKpqi8YxqC
         dP53O5AVKe6XApwiVj3HHnXv0JSSTWpG2fOUHChkn/LI5cCTA8F+RcxdR7/+N/x6ekbU
         lWTWrtebGNWmj4L4KbIOOi+1E141sp4t/HxzrqWTHErDvPD+h048t3LtLe5pvYWFIXXA
         C1jQ==
X-Gm-Message-State: AOAM531q/+rcANmLFvOo/WR0TY10Ue9JSfvkKV6ejygn2EwzzPj3aq10
        BL5jKKcnVyrDAhGgWLX3SDloQ0V+92JSUGz6nVc=
X-Google-Smtp-Source: ABdhPJzxtIiHqfyqo+IRbag4UiuoAbDGUNbXkksK9EuejzR6ZOvLju/wtheTWoT9AtX0WugMwsbvLK4EZQdv+vBHv+k=
X-Received: by 2002:a2e:b8d2:: with SMTP id s18mr12466319ljp.148.1620486639311;
 Sat, 08 May 2021 08:10:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu3m6FWWqrfOeQugXWGZOPiEE+Xgk8wc0rn8OgLRVPSWQ@mail.gmail.com>
 <98a3e99b-3d2e-0480-55db-f843c7016351@talpey.com>
In-Reply-To: <98a3e99b-3d2e-0480-55db-f843c7016351@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 8 May 2021 10:10:28 -0500
Message-ID: <CAH2r5ms-f7YRxeOHPQnGn_+n5dVaCE-WHzfNAstvLjT2HcfhDw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] 3 small multichannel client patches
To:     Tom Talpey <tom@talpey.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000801e4005c1d2f2c2"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000801e4005c1d2f2c2
Content-Type: text/plain; charset="UTF-8"

On Sat, May 8, 2021 at 8:29 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 5/7/2021 9:13 PM, Steve French wrote:
> > 1) we were not setting CAP_MULTICHANNEL on negotiate request
>
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index e36c2a867783..a8bf43184773 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -841,6 +841,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
> >               req->SecurityMode = 0;
> >
> >       req->Capabilities = cpu_to_le32(server->vals->req_capabilities);
> > +     if (ses->chan_max > 1)
> > +             req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
> >
> >       /* ClientGUID must be zero for SMB2.02 dialect */
> >       if (server->vals->protocol_id == SMB20_PROT_ID)
> > @@ -1032,6 +1034,9 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
> >
> >       pneg_inbuf->Capabilities =
> >                       cpu_to_le32(server->vals->req_capabilities);
> > +     if (tcon->ses->chan_max > 1)
> > +             pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
> > +
>
> This doesn't look quite right, and it can lead to failed negotiate by
> setting CAP_MULTI_CHANNEL when the server didn't actually send the bit.
> Have you tested this with servers that don't do multichannel?

Yes.   Validate negotiate ioctl request is supposed to validate what
the client sent not what the server responded, so according to
MS-SMB2, I must send in the ioctl what I sent before on negprot
request

Section 3.2.5.5 says for validate negotiate "Capabilities is set to
Connection.ClientCapabilities."  where
"Connection.ClientCapabilities: The capabilities sent by the client in
the SMB2 NEGOTIATE Request"   (not what the server responded with,
what the ClientCapabilities were sent)

I tested it with two cases that don't support multichannel: Samba, and
also an azure server target where multichannel was disabled.


>
> > 2) we were ignoring whether the server set CAP_NEGOTIATE in the response
>
> Is this "CAP_NEGOTIATE" a typo? I think you mean CAP_MULTI_CHANNEL.

Yes - typo

>
> > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> > index 63d517b9f2ff..a391ca3166f3 100644
> > --- a/fs/cifs/sess.c
> > +++ b/fs/cifs/sess.c
> > @@ -97,6 +97,12 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
> >               return 0;
> >       }
> >
> > +     if ((ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL) == false) {
>
> This compares a bit to a boolean. "false" should be "0"?

I changed it to the more common style  if (!(ses->...capabilities & SMB@....))
>
> > +             cifs_dbg(VFS, "server does not support CAP_MULTI_CHANNEL, multichannel disabled\n");
>
> The wording could be clearer. Technically speaking, the server does not
> support _multichannel_, which it indicated by not setting CAP_MULTI_CHANNEL.
> Also, wouldn't it be more useful to add the servername to this message?
>         "server %s does not support multichannel, using single channel"
> or similar.

Good idea

> > 3) we were silently ignoring multichannel when "max_channels" was > 1
> > but the user forgot to include "multichannel" in mount line.
>
>  > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
>  > index 3bcf881c3ae9..8f7af6fcdc76 100644
>  > --- a/fs/cifs/fs_context.c
>  > +++ b/fs/cifs/fs_context.c
>  > @@ -1021,6 +1021,9 @@ static int smb3_fs_context_parse_param(struct
> fs_context *fc,
>  >                      goto cifs_parse_mount_err;
>  >              }
>  >              ctx->max_channels = result.uint_32;
>  > +            /* If more than one channel requested ... they want multichan */
>  > +            if ((ctx->multichannel == false) && (result.uint_32 > 1))
>  > +                    ctx->multichannel = true;
>
> Wouldn't this be clearer and simpler as just "if (result.uint32 > 1)" ?

made that change

Updated two of the patches as described above - attached.
-- 
Thanks,

Steve

--000000000000801e4005c1d2f2c2
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0003-smb3-if-max_channels-set-to-more-than-one-channel-re.patch"
Content-Disposition: attachment; 
	filename="0003-smb3-if-max_channels-set-to-more-than-one-channel-re.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kofvupn00>
X-Attachment-Id: f_kofvupn00

RnJvbSAxZmFlOWNmODI0MmY3ZDcwMjhmYTk1ZjFjZmQyNGI2Nzk0MmI4YjRlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgNyBNYXkgMjAyMSAxOTozMzo1MSAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMy80
XSBzbWIzOiBpZiBtYXhfY2hhbm5lbHMgc2V0IHRvIG1vcmUgdGhhbiBvbmUgY2hhbm5lbAogcmVx
dWVzdCBtdWx0aWNoYW5uZWwKCk1vdW50aW5nIHdpdGggIm11bHRpY2hhbm5lbCIgaXMgb2J2aW91
c2x5IGltcGxpZWQgaWYgdXNlciByZXF1ZXN0ZWQKbW9yZSB0aGFuIG9uZSBjaGFubmVsIG9uIG1v
dW50IChpZSBtb3VudCBwYXJtIG1heF9jaGFubmVscz4xKS4KQ3VycmVudGx5IGJvdGggaGF2ZSB0
byBiZSBzcGVjaWZpZWQuIEZpeCB0aGF0IHNvIHRoYXQgaWYgbWF4X2NoYW5uZWxzCmlzIGdyZWF0
ZXIgdGhhbiAxIG9uIG1vdW50LCBlbmFibGUgbXVsdGljaGFubmVsIHJhdGhlciB0aGFuIHNpbGVu
dGx5CmZhbGxpbmcgYmFjayB0byBub24tbXVsdGljaGFubmVsLgoKU2lnbmVkLW9mZi1ieTogU3Rl
dmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgpSZXZpZXdlZC1ieTogU2h5YW0gUHJh
c2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2ZzX2NvbnRleHQuYyB8
IDMgKysrCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMv
Y2lmcy9mc19jb250ZXh0LmMgYi9mcy9jaWZzL2ZzX2NvbnRleHQuYwppbmRleCAzYmNmODgxYzNh
ZTkuLjVkMjFjZDkwNTMxNSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9mc19jb250ZXh0LmMKKysrIGIv
ZnMvY2lmcy9mc19jb250ZXh0LmMKQEAgLTEwMjEsNiArMTAyMSw5IEBAIHN0YXRpYyBpbnQgc21i
M19mc19jb250ZXh0X3BhcnNlX3BhcmFtKHN0cnVjdCBmc19jb250ZXh0ICpmYywKIAkJCWdvdG8g
Y2lmc19wYXJzZV9tb3VudF9lcnI7CiAJCX0KIAkJY3R4LT5tYXhfY2hhbm5lbHMgPSByZXN1bHQu
dWludF8zMjsKKwkJLyogSWYgbW9yZSB0aGFuIG9uZSBjaGFubmVsIHJlcXVlc3RlZCAuLi4gdGhl
eSB3YW50IG11bHRpY2hhbiAqLworCQlpZiAocmVzdWx0LnVpbnRfMzIgPiAxKQorCQkJY3R4LT5t
dWx0aWNoYW5uZWwgPSB0cnVlOwogCQlicmVhazsKIAljYXNlIE9wdF9oYW5kbGV0aW1lb3V0Ogog
CQljdHgtPmhhbmRsZV90aW1lb3V0ID0gcmVzdWx0LnVpbnRfMzI7Ci0tIAoyLjI3LjAKCg==
--000000000000801e4005c1d2f2c2
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-smb3-do-not-attempt-multichannel-to-server-which-doe.patch"
Content-Disposition: attachment; 
	filename="0002-smb3-do-not-attempt-multichannel-to-server-which-doe.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kofvupnj1>
X-Attachment-Id: f_kofvupnj1

RnJvbSBmMjQyMWU1ZWZjYzI1ZTFmN2E1NjYxZDBhY2UwNTljMWRkYWY0YjhkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgNyBNYXkgMjAyMSAyMDowMDo0MSAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMi80
XSBzbWIzOiBkbyBub3QgYXR0ZW1wdCBtdWx0aWNoYW5uZWwgdG8gc2VydmVyIHdoaWNoIGRvZXMK
IG5vdCBzdXBwb3J0IGl0CgpXZSB3ZXJlIGlnbm9yaW5nIENBUF9NVUxUSV9DSEFOTkVMIGluIHRo
ZSBzZXJ2ZXIgcmVzcG9uc2UgLSBpZiB0aGUKc2VydmVyIGRvZXNuJ3Qgc3VwcG9ydCBtdWx0aWNo
YW5uZWwgd2Ugc2hvdWxkIG5vdCBiZSBhdHRlbXB0aW5nIGl0LgoKU2VlIE1TLVNNQjIgc2VjdGlv
biAzLjIuNS4yCgpSZXZpZXdlZC1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0
LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29t
PgotLS0KIGZzL2NpZnMvc2Vzcy5jIHwgNiArKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2Vy
dGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3Nlc3MuYyBiL2ZzL2NpZnMvc2Vzcy5jCmlu
ZGV4IDYzZDUxN2I5ZjJmZi4uYTkyYTFmYjdjYjUyIDEwMDY0NAotLS0gYS9mcy9jaWZzL3Nlc3Mu
YworKysgYi9mcy9jaWZzL3Nlc3MuYwpAQCAtOTcsNiArOTcsMTIgQEAgaW50IGNpZnNfdHJ5X2Fk
ZGluZ19jaGFubmVscyhzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLCBzdHJ1Y3QgY2lmc19z
ZXMgKnNlcykKIAkJcmV0dXJuIDA7CiAJfQogCisJaWYgKCEoc2VzLT5zZXJ2ZXItPmNhcGFiaWxp
dGllcyAmIFNNQjJfR0xPQkFMX0NBUF9NVUxUSV9DSEFOTkVMKSkgeworCQljaWZzX2RiZyhWRlMs
ICJzZXJ2ZXIgJXMgZG9lcyBub3Qgc3VwcG9ydCBtdWx0aWNoYW5uZWxcbiIsIHNlcy0+c2VydmVy
LT5ob3N0bmFtZSk7CisJCXNlcy0+Y2hhbl9tYXggPSAxOworCQlyZXR1cm4gMDsKKwl9CisKIAkv
KgogCSAqIE1ha2UgYSBjb3B5IG9mIHRoZSBpZmFjZSBsaXN0IGF0IHRoZSB0aW1lIGFuZCB1c2Ug
dGhhdAogCSAqIGluc3RlYWQgc28gYXMgdG8gbm90IGhvbGQgdGhlIGlmYWNlIHNwaW5sb2NrIGZv
ciBvcGVuaW5nCi0tIAoyLjI3LjAKCg==
--000000000000801e4005c1d2f2c2--
