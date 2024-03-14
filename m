Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FB2745C4;
	Thu, 14 Mar 2024 17:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710436621; cv=none; b=PGKVgO+7l5eztiQKQHpmQsmkDiUjA8uARjjLwKvfFuOuyxNTkrksS6rrsiAvIamQCpoqw2z4yMNQeRf9f/zyeuY5GDKazfRu/VhG+ZWih5ziOsrTdZMPNyhpyLlGxrX0gKCuNCF8XkyvYASMn+WKxQQqffg+XA0xnfNikwgmHww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710436621; c=relaxed/simple;
	bh=yEAjYlZS8Vh+1fKydHwx2mrd3ZlQrmK6jZP9pcEiSao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZGqOSTOXrrYjTNvqNgDFM61OQRO6Udm9I/XOm6Nojudcf0XVFXSiIuCkyvfR5Ell5y56Ez+uyA1B9EtKPtkyB8c3AIGdtnNVnNRE+E92B8DMhbT/AeyLyQhOmiAYklF41KFfQ9d5rvVYOBbd7a6gMLBVozfnR1pzmdlXWladsqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mdRwXXn9; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mdRwXXn9"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5101cd91017so1959503e87.2;
        Thu, 14 Mar 2024 10:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710436618; x=1711041418; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ps1g2qP3yY2atcEULtu4ABg5GWK/bG/BRx3OnM+x7Uk=;
        b=mdRwXXn9pEgSXjeKzudqq40ZcbZ841WqZsPn+jjqkxlCuB/VO3BXKb57oDWolWaXYU
         NFbGTeKMm42yjYstDFh7ozRhQUlp/s91VoBotmYkvE35Ft+rbBQCoZITQc0z9Wj2h9Xt
         0cApql2m6YTR8Iey5BR1qO2ofuMMoUVJOgtYss3sX/7TkUxMdZ/WGRQYWAX/LEo06jbR
         1gMZtEpUMDVHYw9jcq6iBs7fAL4ShQmJmIrdiCQXfs0BxpNnTwCfhVj7CCaeEDL8+6hW
         XpOILbCZSrD0KVWUU9aeYvu+McatPrjWTvbzS5oLQEosq1+L6N1lTUHCqIx25Q92LiVP
         90Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710436618; x=1711041418;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ps1g2qP3yY2atcEULtu4ABg5GWK/bG/BRx3OnM+x7Uk=;
        b=jyNrPdgHNbXMxEt3sDVCrd5SFW8hkJdX+oUBxFUesIt4OsOJ/qxvSCgoEJ6HG/BxAI
         6HVFufgP8dS207EU/FqH8jo5JZ34voQQPdt/Q9YgRXtA9sPZIQgT79cJIp5+kLdRpEed
         Tbmg8ZN4U6M/udn4512eTkCccl3XINiFL3JtU7uK01GaxYgN2unEMy6kY2aT7gBbs/w8
         AWYin1DtaJUNqWnnv1AK94sKU/aPtycN6LawqlJ21HzuWzDF/3W1g8CFc6XKRoFZc+Ou
         +5aDba2OFfm5q5ZJsc+LWxdeoplUIkgTwHlY0gnnrSDHOlYK+77j1LgSjUq8PlOAwCvC
         r5Mg==
X-Forwarded-Encrypted: i=1; AJvYcCVLHfxyjc5a9wvMvu6d9GARBiHXZf+WWj0mN1vOao2kq50MlUX0QxoHs4h1NOeMWImgCRYv8KOE2hmyjA/u7ky1OoebWd/F
X-Gm-Message-State: AOJu0YwV+4Aw5rBjG1x2Lt/KxsV/iigs5YiKBRyvPst+jRrxQLith6b0
	dFgO9Uh3NwMUzk0m17v7KXyS/LqtlgH2jVh25u5hqlqxO5eDIGPGbk5ew8pODi2j6DDpnmnWJEN
	t/l+VSoYtW+WsAqUwMA4LgnCjzmDDZY/eg74=
X-Google-Smtp-Source: AGHT+IGnNkZfIrZK0fk9oI9S6n4rZ91KqKQ0oQkBcAnZKu/84cEtprsvR3FCp8gL91zrVZtlMb3PV5GClNq4tnWAFJY=
X-Received: by 2002:a05:6512:3e1e:b0:513:4fb4:5388 with SMTP id
 i30-20020a0565123e1e00b005134fb45388mr2105234lfv.41.1710436617459; Thu, 14
 Mar 2024 10:16:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240313104041.188204-1-sprasad@microsoft.com> <CAH2r5mtDe_E9=mGx1mOjfEMfgdhV9W=TjijXOdqgTkasVE81=g@mail.gmail.com>
In-Reply-To: <CAH2r5mtDe_E9=mGx1mOjfEMfgdhV9W=TjijXOdqgTkasVE81=g@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 14 Mar 2024 12:16:45 -0500
Message-ID: <CAH2r5mu-8eyykEN4yaQ1C-yzg0_hdHDE=x2rxjuxh1sZFHirAA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: reduce warning log level for server not
 advertising interfaces
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	Shyam Prasad N <sprasad@microsoft.com>, Stable <stable@vger.kernel.org>, 
	=?UTF-8?B?SmFuIMSMZXJtw6Fr?= <sairon@sairon.cz>
Content-Type: multipart/mixed; boundary="000000000000fec02d0613a20e79"

--000000000000fec02d0613a20e79
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated patch to change to warn once, and to fix a minor checkpatch
warning (about format of stable tag)


On Wed, Mar 13, 2024 at 11:45=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> what about simply a "warn_once" since it is useful for the user to
> know that their server does not advertise interfaces so can affect
> performance (multichannel) and perhaps some reconnect scenarios.
>
> On Wed, Mar 13, 2024 at 5:40=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > Several users have reported this log getting dumped too regularly to
> > kernel log. The likely root cause has been identified, and it suggests
> > that this situation is expected for some configurations
> > (for example SMB2.1).
> >
> > Since the function returns appropriately even for such cases, it is
> > fairly harmless to make this a debug log. When needed, the verbosity
> > can be increased to capture this log.
> >
> > Cc: Stable <stable@vger.kernel.org>
> > Reported-by: Jan =C4=8Cerm=C3=A1k <sairon@sairon.cz>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/sess.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > index 8f37373fd333..37cdf5b55108 100644
> > --- a/fs/smb/client/sess.c
> > +++ b/fs/smb/client/sess.c
> > @@ -230,7 +230,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
> >                 spin_lock(&ses->iface_lock);
> >                 if (!ses->iface_count) {
> >                         spin_unlock(&ses->iface_lock);
> > -                       cifs_dbg(VFS, "server %s does not advertise int=
erfaces\n",
> > +                       cifs_dbg(FYI, "server %s does not advertise int=
erfaces\n",
> >                                       ses->server->hostname);
> >                         break;
> >                 }
> > @@ -396,7 +396,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct=
 TCP_Server_Info *server)
> >         spin_lock(&ses->iface_lock);
> >         if (!ses->iface_count) {
> >                 spin_unlock(&ses->iface_lock);
> > -               cifs_dbg(VFS, "server %s does not advertise interfaces\=
n", ses->server->hostname);
> > +               cifs_dbg(FYI, "server %s does not advertise interfaces\=
n", ses->server->hostname);
> >                 return;
> >         }
> >
> > --
> > 2.34.1
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

--000000000000fec02d0613a20e79
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0002-cifs-reduce-warning-log-level-for-server-not-adverti.patch"
Content-Disposition: attachment; 
	filename="0002-cifs-reduce-warning-log-level-for-server-not-adverti.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ltrhshwa0>
X-Attachment-Id: f_ltrhshwa0

RnJvbSAyMWRkOGRmNjVhN2Y4N2VjYzkyOGFkMzI1YWIxNjNhYjA4YTU1NmJlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDEzIE1hciAyMDI0IDEwOjQwOjQwICswMDAwClN1YmplY3Q6IFtQQVRDSCAy
LzRdIGNpZnM6IHJlZHVjZSB3YXJuaW5nIGxvZyBsZXZlbCBmb3Igc2VydmVyIG5vdCBhZHZlcnRp
c2luZwogaW50ZXJmYWNlcwpNSU1FLVZlcnNpb246IDEuMApDb250ZW50LVR5cGU6IHRleHQvcGxh
aW47IGNoYXJzZXQ9VVRGLTgKQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdAoKU2V2ZXJh
bCB1c2VycyBoYXZlIHJlcG9ydGVkIHRoaXMgbG9nIGdldHRpbmcgZHVtcGVkIHRvbyByZWd1bGFy
bHkgdG8Ka2VybmVsIGxvZy4gVGhlIGxpa2VseSByb290IGNhdXNlIGhhcyBiZWVuIGlkZW50aWZp
ZWQsIGFuZCBpdCBzdWdnZXN0cwp0aGF0IHRoaXMgc2l0dWF0aW9uIGlzIGV4cGVjdGVkIGZvciBz
b21lIGNvbmZpZ3VyYXRpb25zCihmb3IgZXhhbXBsZSBTTUIyLjEpLgoKU2luY2UgdGhlIGZ1bmN0
aW9uIHJldHVybnMgYXBwcm9wcmlhdGVseSBldmVuIGZvciBzdWNoIGNhc2VzLCBpdCBpcwpmYWly
bHkgaGFybWxlc3MgdG8gbWFrZSB0aGlzIGEgZGVidWcgbG9nLiBXaGVuIG5lZWRlZCwgdGhlIHZl
cmJvc2l0eQpjYW4gYmUgaW5jcmVhc2VkIHRvIGNhcHR1cmUgdGhpcyBsb2cuCgpDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZwpSZXBvcnRlZC1ieTogSmFuIMSMZXJtw6FrIDxzYWlyb25Ac2Fpcm9u
LmN6PgpTaWduZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0t
LQogZnMvc21iL2NsaWVudC9zZXNzLmMgfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zZXNz
LmMgYi9mcy9zbWIvY2xpZW50L3Nlc3MuYwppbmRleCA4ZjM3MzczZmQzMzMuLjMyMTZmNzg2OTA4
ZiAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zZXNzLmMKKysrIGIvZnMvc21iL2NsaWVudC9z
ZXNzLmMKQEAgLTIzMCw3ICsyMzAsNyBAQCBpbnQgY2lmc190cnlfYWRkaW5nX2NoYW5uZWxzKHN0
cnVjdCBjaWZzX3NlcyAqc2VzKQogCQlzcGluX2xvY2soJnNlcy0+aWZhY2VfbG9jayk7CiAJCWlm
ICghc2VzLT5pZmFjZV9jb3VudCkgewogCQkJc3Bpbl91bmxvY2soJnNlcy0+aWZhY2VfbG9jayk7
Ci0JCQljaWZzX2RiZyhWRlMsICJzZXJ2ZXIgJXMgZG9lcyBub3QgYWR2ZXJ0aXNlIGludGVyZmFj
ZXNcbiIsCisJCQljaWZzX2RiZyhPTkNFLCAic2VydmVyICVzIGRvZXMgbm90IGFkdmVydGlzZSBp
bnRlcmZhY2VzXG4iLAogCQkJCSAgICAgIHNlcy0+c2VydmVyLT5ob3N0bmFtZSk7CiAJCQlicmVh
azsKIAkJfQpAQCAtMzk2LDcgKzM5Niw3IEBAIGNpZnNfY2hhbl91cGRhdGVfaWZhY2Uoc3RydWN0
IGNpZnNfc2VzICpzZXMsIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKIAlzcGluX2xv
Y2soJnNlcy0+aWZhY2VfbG9jayk7CiAJaWYgKCFzZXMtPmlmYWNlX2NvdW50KSB7CiAJCXNwaW5f
dW5sb2NrKCZzZXMtPmlmYWNlX2xvY2spOwotCQljaWZzX2RiZyhWRlMsICJzZXJ2ZXIgJXMgZG9l
cyBub3QgYWR2ZXJ0aXNlIGludGVyZmFjZXNcbiIsIHNlcy0+c2VydmVyLT5ob3N0bmFtZSk7CisJ
CWNpZnNfZGJnKE9OQ0UsICJzZXJ2ZXIgJXMgZG9lcyBub3QgYWR2ZXJ0aXNlIGludGVyZmFjZXNc
biIsIHNlcy0+c2VydmVyLT5ob3N0bmFtZSk7CiAJCXJldHVybjsKIAl9CiAKLS0gCjIuNDAuMQoK
--000000000000fec02d0613a20e79--
