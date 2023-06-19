Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32B4EB64D9
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Jun 2023 17:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjFSR1V (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Jun 2023 13:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjFSR1U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Jun 2023 13:27:20 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A32D198
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jun 2023 10:27:18 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id 3f1490d57ef6-bcc29cdcdc9so3867131276.0
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jun 2023 10:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687195637; x=1689787637;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yJTC7es4p1+9AYuI+4mdTM2I3Ti/NukgQc7yD6PhYBE=;
        b=qf/V7tXh5Qo6LMCHKoW9kd0JQuSY5Niu6lmDQ4oGdjn6A7qpw7kohOSzFLYyJvHeVJ
         HytLS2MNBykiRqdJ4pa9bBhvdmvEWAJvQR9QC0QeRm6VdHC9CHCzzjozp5aG0ueWQ72U
         dAdVZ/UFpIx3F1pV8ct7l/M6KK7nfmzx6r5xwu6CfNdsePXaXwS7MZz2t0LeO8l9Im0e
         9LrLjpjUDrea4HYMcg0hfST0xU49MUNL/5b4cydFTJBnho3TBj/GjwP4ZzA6XcAbR4xb
         hXOhC5V/bVqI1M1RdDg8Eq7b4PKH2T8uA94ghEmL8YZGSsnI2gyhcLeA0Sx72Ragrv9e
         iB5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687195637; x=1689787637;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yJTC7es4p1+9AYuI+4mdTM2I3Ti/NukgQc7yD6PhYBE=;
        b=fgQvzUSYR+8DNxea2SyeKjMF4wOcTudU+Dh0jF0OntRTcQWV5eMRT/yIHCzP9JpBJ3
         nd9NLeze7dSC2+nfHflIhM2c3PU49Eh0HGDBdFXh6rq3EPz9FsGBYEfD2iPVf/wTn1bp
         Fxhh3d7woa7tL+0dfynG51f+fPzZeTN+XttBbmlIv7ebYa3MJ1ywUq5NxsrL0jRvVykt
         1J5bOJOJkM/IK4OS7W9Mi31XdKgLnQ8PmxDVihBl5mTXUF73nkr6pWRur+ZMeTr5l+Pk
         xHILpCDx9dBsJm3qkVIaA8S7QBNUC0VdXALarqr0B6C+66cU0xTk1hLqLPUACRaZHFmV
         BLWg==
X-Gm-Message-State: AC+VfDwTbSYCdYAsPCcEFiBpsXO2E2XZFlSxU6qNcedP8/AiWLL76q0N
        Ffn7RMc7f3Xeh0qaoXIOvXUBvrjF+XOIW1Tbo/htIDdM3cM=
X-Google-Smtp-Source: ACHHUZ7Z7YjsKWVEwFQnDE81tHbutaVZ7lx2wF8B19/uVsepuANDYHuzqWT1Zi7aryb7MKw5wVQSAH451L2ZrjbaigI=
X-Received: by 2002:a25:278a:0:b0:bf5:7578:743f with SMTP id
 n132-20020a25278a000000b00bf57578743fmr1828160ybn.40.1687195637603; Mon, 19
 Jun 2023 10:27:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230619033436.808928-1-bharathsm@microsoft.com>
 <CAH2r5msQ_FXVuhhp6FzeVr3rVR5pw=_dQ2da=k+jtqqpouKWZg@mail.gmail.com> <5a83a490-dc32-901c-5ea5-85458f815e0d@talpey.com>
In-Reply-To: <5a83a490-dc32-901c-5ea5-85458f815e0d@talpey.com>
From:   Bharath SM <bharathsm.hsk@gmail.com>
Date:   Mon, 19 Jun 2023 22:57:06 +0530
Message-ID: <CAGypqWyyL-1OU2XZyOPtKdvTi_M+hRdJXO+Y5VizvoE+0pwN7g@mail.gmail.com>
Subject: Re: [PATCH] SMB3: Do not send lease break acknowledgment if all file
 handles have been closed
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>, sfrench@samba.org,
        pc@manguebit.com, lsahlber@redhat.com, sprasad@microsoft.com,
        linux-cifs@vger.kernel.org, bharathsm@microsoft.com,
        nspmangalore@gmail.com
Content-Type: multipart/mixed; boundary="000000000000a5a42805fe7ed89c"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a5a42805fe7ed89c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please find the attached patch with suggested changes.

On Mon, Jun 19, 2023 at 5:40=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 6/19/2023 12:54 AM, Steve French wrote:
> > tentatively merged into cifs-2.6.git for-next pending more testing
> >
> > On Sun, Jun 18, 2023 at 10:57=E2=80=AFPM Bharath SM <bharathsm.hsk@gmai=
l.com> wrote:
> >>
> >> In case if all existing file handles are deferred handles and if all o=
f
> >> them gets closed due to handle lease break then we dont need to send
> >> lease break acknowledgment to server, because last handle close will b=
e
> >> considered as lease break ack.
> >> After closing deferred handels, we check for openfile list of inode,
> >> if its empty then we skip sending lease break ack.
> >>
> >> Fixes: 59a556aebc43 ("SMB3: drop reference to cfile before sending opl=
ock break")
> >> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> >> ---
> >>   fs/smb/client/file.c | 7 +++++--
> >>   1 file changed, 5 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> >> index 051283386e22..b8a3d60e7ac4 100644
> >> --- a/fs/smb/client/file.c
> >> +++ b/fs/smb/client/file.c
> >> @@ -4941,7 +4941,9 @@ void cifs_oplock_break(struct work_struct *work)
> >>           * not bother sending an oplock release if session to server =
still is
> >>           * disconnected since oplock already released by the server
> >>           */
>
> The comment just above is a woefully incorrect SMB1 artifact, and
> it's even worse now.
>
> Here's what it currently says:
>
> >       /*
> >        * releasing stale oplock after recent reconnect of smb session u=
sing
> >        * a now incorrect file handle is not a data integrity issue but =
do
> >        * not bother sending an oplock release if session to server stil=
l is
> >        * disconnected since oplock already released by the server
> >        */
>
> One option is deleting it entirely, but I suggest:
>
> "MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do not require
>   an acknowledgement to be sent when the file has already been closed."
>
> >> -       if (!oplock_break_cancelled) {
> >> +       spin_lock(&cinode->open_file_lock);
> >> +       if (!oplock_break_cancelled && !list_empty(&cinode->openFileLi=
st)) {
> >> +               spin_unlock(&cinode->open_file_lock);
> >>                  /* check for server null since can race with kill_sb =
calling tree disconnect */
> >>                  if (tcon->ses && tcon->ses->server) {
> >>                          rc =3D tcon->ses->server->ops->oplock_respons=
e(tcon, persistent_fid,
> >> @@ -4949,7 +4951,8 @@ void cifs_oplock_break(struct work_struct *work)
> >>                          cifs_dbg(FYI, "Oplock release rc =3D %d\n", r=
c);
> >>                  } else
> >>                          pr_warn_once("lease break not sent for unmoun=
ted share\n");
>
> Also, I think this warning is entirely pointless, in addition to
> being similarly incorrect post-SMB1. Delete it. You will be able
> to refactor the if/else branches more clearly in this case too.
>
> With those changes considered,
> Reviewed-by: Tom Talpey <tom@talpey.com>
>
> Tom.
>
> >> -       }
> >> +       } else
> >> +               spin_unlock(&cinode->open_file_lock);
> >>
> >>          cifs_done_oplock_break(cinode);
> >>   }
> >> --
> >> 2.34.1
> >>
> >
> >

--000000000000a5a42805fe7ed89c
Content-Type: application/octet-stream; 
	name="0001-SMB3-Do-not-send-lease-break-acknowledgment-if-all-f.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Do-not-send-lease-break-acknowledgment-if-all-f.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lj34ndn90>
X-Attachment-Id: f_lj34ndn90

RnJvbSBkNzkyYjg4ODViYzE3ODg1ZmNjNzEzOTc2YWE4NjNiNGRkMTMxNGIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4K
RGF0ZTogU3VuLCAxOCBKdW4gMjAyMyAxOTowMjoyNCArMDAwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjM6IERvIG5vdCBzZW5kIGxlYXNlIGJyZWFrIGFja25vd2xlZGdtZW50IGlmIGFsbCBmaWxlCiBo
YW5kbGVzIGhhdmUgYmVlbiBjbG9zZWQKCkluIGNhc2UgaWYgYWxsIGV4aXN0aW5nIGZpbGUgaGFu
ZGxlcyBhcmUgZGVmZXJyZWQgaGFuZGxlcyBhbmQgaWYgYWxsIG9mCnRoZW0gZ2V0cyBjbG9zZWQg
ZHVlIHRvIGhhbmRsZSBsZWFzZSBicmVhayB0aGVuIHdlIGRvbnQgbmVlZCB0byBzZW5kCmxlYXNl
IGJyZWFrIGFja25vd2xlZGdtZW50IHRvIHNlcnZlciwgYmVjYXVzZSBsYXN0IGhhbmRsZSBjbG9z
ZSB3aWxsIGJlCmNvbnNpZGVyZWQgYXMgbGVhc2UgYnJlYWsgYWNrLgpBZnRlciBjbG9zaW5nIGRl
ZmVycmVkIGhhbmRlbHMsIHdlIGNoZWNrIGZvciBvcGVuZmlsZSBsaXN0IG9mIGlub2RlLAppZiBp
dHMgZW1wdHkgdGhlbiB3ZSBza2lwIHNlbmRpbmcgbGVhc2UgYnJlYWsgYWNrLgoKRml4ZXM6IDU5
YTU1NmFlYmM0MyAoIlNNQjM6IGRyb3AgcmVmZXJlbmNlIHRvIGNmaWxlIGJlZm9yZSBzZW5kaW5n
IG9wbG9jayBicmVhayIpClNpZ25lZC1vZmYtYnk6IEJoYXJhdGggU00gPGJoYXJhdGhzbUBtaWNy
b3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvZmlsZS5jIHwgMjUgKysrKysrKysrKysrLS0t
LS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvZmlsZS5jIGIvZnMvc21iL2NsaWVudC9m
aWxlLmMKaW5kZXggMDUxMjgzMzg2ZTIyLi4xYTg1NGRjMjA0ODIgMTAwNjQ0Ci0tLSBhL2ZzL3Nt
Yi9jbGllbnQvZmlsZS5jCisrKyBiL2ZzL3NtYi9jbGllbnQvZmlsZS5jCkBAIC00OTM2LDIwICs0
OTM2LDE5IEBAIHZvaWQgY2lmc19vcGxvY2tfYnJlYWsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3Jr
KQogCiAJX2NpZnNGaWxlSW5mb19wdXQoY2ZpbGUsIGZhbHNlIC8qIGRvIG5vdCB3YWl0IGZvciBv
dXJzZWxmICovLCBmYWxzZSk7CiAJLyoKLQkgKiByZWxlYXNpbmcgc3RhbGUgb3Bsb2NrIGFmdGVy
IHJlY2VudCByZWNvbm5lY3Qgb2Ygc21iIHNlc3Npb24gdXNpbmcKLQkgKiBhIG5vdyBpbmNvcnJl
Y3QgZmlsZSBoYW5kbGUgaXMgbm90IGEgZGF0YSBpbnRlZ3JpdHkgaXNzdWUgYnV0IGRvCi0JICog
bm90IGJvdGhlciBzZW5kaW5nIGFuIG9wbG9jayByZWxlYXNlIGlmIHNlc3Npb24gdG8gc2VydmVy
IHN0aWxsIGlzCi0JICogZGlzY29ubmVjdGVkIHNpbmNlIG9wbG9jayBhbHJlYWR5IHJlbGVhc2Vk
IGJ5IHRoZSBzZXJ2ZXIKKwkgKiBNUy1TTUIyIDMuMi41LjE5LjEgYW5kIDMuMi41LjE5LjIgKGFu
ZCBNUy1DSUZTIDMuMi41LjQyKSBkbyBub3QgcmVxdWlyZQorCSAqIGFuIGFja25vd2xlZGdtZW50
IHRvIGJlIHNlbnQgd2hlbiB0aGUgZmlsZSBoYXMgYWxyZWFkeSBiZWVuIGNsb3NlZC4KKwkgKiBj
aGVjayBmb3Igc2VydmVyIG51bGwsIHNpbmNlIGNhbiByYWNlIHdpdGgga2lsbF9zYiBjYWxsaW5n
IHRyZWUgZGlzY29ubmVjdC4KIAkgKi8KLQlpZiAoIW9wbG9ja19icmVha19jYW5jZWxsZWQpIHsK
LQkJLyogY2hlY2sgZm9yIHNlcnZlciBudWxsIHNpbmNlIGNhbiByYWNlIHdpdGgga2lsbF9zYiBj
YWxsaW5nIHRyZWUgZGlzY29ubmVjdCAqLwotCQlpZiAodGNvbi0+c2VzICYmIHRjb24tPnNlcy0+
c2VydmVyKSB7Ci0JCQlyYyA9IHRjb24tPnNlcy0+c2VydmVyLT5vcHMtPm9wbG9ja19yZXNwb25z
ZSh0Y29uLCBwZXJzaXN0ZW50X2ZpZCwKLQkJCQl2b2xhdGlsZV9maWQsIG5ldF9maWQsIGNpbm9k
ZSk7Ci0JCQljaWZzX2RiZyhGWUksICJPcGxvY2sgcmVsZWFzZSByYyA9ICVkXG4iLCByYyk7Ci0J
CX0gZWxzZQotCQkJcHJfd2Fybl9vbmNlKCJsZWFzZSBicmVhayBub3Qgc2VudCBmb3IgdW5tb3Vu
dGVkIHNoYXJlXG4iKTsKLQl9CisJc3Bpbl9sb2NrKCZjaW5vZGUtPm9wZW5fZmlsZV9sb2NrKTsK
KwlpZiAodGNvbi0+c2VzICYmIHRjb24tPnNlcy0+c2VydmVyICYmICFvcGxvY2tfYnJlYWtfY2Fu
Y2VsbGVkICYmCisJCQkJCSFsaXN0X2VtcHR5KCZjaW5vZGUtPm9wZW5GaWxlTGlzdCkpIHsKKwkJ
c3Bpbl91bmxvY2soJmNpbm9kZS0+b3Blbl9maWxlX2xvY2spOworCQlyYyA9IHRjb24tPnNlcy0+
c2VydmVyLT5vcHMtPm9wbG9ja19yZXNwb25zZSh0Y29uLCBwZXJzaXN0ZW50X2ZpZCwKKwkJCQkJ
CXZvbGF0aWxlX2ZpZCwgbmV0X2ZpZCwgY2lub2RlKTsKKwkJY2lmc19kYmcoRllJLCAiT3Bsb2Nr
IHJlbGVhc2UgcmMgPSAlZFxuIiwgcmMpOworCX0gZWxzZQorCQlzcGluX3VubG9jaygmY2lub2Rl
LT5vcGVuX2ZpbGVfbG9jayk7CiAKIAljaWZzX2RvbmVfb3Bsb2NrX2JyZWFrKGNpbm9kZSk7CiB9
Ci0tIAoyLjM0LjEKCg==
--000000000000a5a42805fe7ed89c--
