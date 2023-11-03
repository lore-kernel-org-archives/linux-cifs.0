Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7963BC4167B
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Nov 2023 00:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbjKCAoO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Nov 2023 20:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbjKCAoN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Nov 2023 20:44:13 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DCCF0
        for <linux-cifs@vger.kernel.org>; Thu,  2 Nov 2023 17:44:11 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-507cd62472dso2823857e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 Nov 2023 17:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698972249; x=1699577049; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FYh422V5BEd7rc+j/guUebB9zYPR5zPOJ9q0B/PY68I=;
        b=VcnQbzmUpcdyoYZ0wJM9uso72ToYSfOjX7/o8FGhwIt67fvBd6NtRDIZD7KOmWo/rx
         A8vMW7t+Shz1gX+3wcLX/XQT3EDtAcX6VaQVIbmxbQQf5OKa5ok5NyJt8TFfWgGjAj3m
         XEOZ9FNjfJeb7RKGgpWikuftz/RcisTxpThAb0rweIxzUTCFsAgSezSvYjVTUgIoHjpk
         l4wFDvGkdbZKWGrgino7nhFZ5TJ8yFjU5UyDMwNzpWEnZ3C2wM6jQkggDLtxBGTtezyt
         UyVXe008R989iD3ZeYlpdWcMtO8jSz3Esfc0l3lCyiglcRHj6wBo6w76M65zCXBg5c7P
         3puA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698972249; x=1699577049;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FYh422V5BEd7rc+j/guUebB9zYPR5zPOJ9q0B/PY68I=;
        b=XpY+TmOlpQ1s4bgP5dRFDQDfotK1nfun+otpe+tWhdlD6n8/krEqcPbPlItzgfGC1Y
         pbDT7v0cOyjwBcMhATr2BFpBwu4ZDUfEf19m/38/irr+AZfOszRHk31kMQnu5Li8bdTX
         ofVnlwtG7mSdjlCLmjLVpt9mrFXw9zhmPLTD1zdJkHtqrzeEL++/CSukSPN+byJpMcsk
         B2YvXKdNcw5zRmwtm01PWFY22gHl8OfdIuUZylccDigdFfNKkAMLFI/40B1gOhrWSoA3
         BYfgdhaFvO82fA3br8si85pJ+5nSrwZNtwi9pIiBG/ybaahCLXzg1LdKlllLWH/7ci/P
         wr2A==
X-Gm-Message-State: AOJu0Yzg8ChX/VJm16lQ2yTzUkJZXuNKqExvxr3YsWJWPPVgjnORTbJr
        3j839F+kOWq7r5Fw0Ot3Gmwyoi3tl/tFd/21ZnbxUr8PpxU=
X-Google-Smtp-Source: AGHT+IEVsBnlT8oATOWObTMLfpC8FvbqEMP9osr0ywKW/BfcWWCGAHeVLaUu+dB4OzfKIf19DXFYsaibI1ySmdgDt6M=
X-Received: by 2002:a19:6553:0:b0:507:bd5f:a40a with SMTP id
 c19-20020a196553000000b00507bd5fa40amr324767lfj.23.1698972248925; Thu, 02 Nov
 2023 17:44:08 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-11-sprasad@microsoft.com>
 <b709f32a96f04ff6136b69605788a2e6.pc@manguebit.com>
In-Reply-To: <b709f32a96f04ff6136b69605788a2e6.pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 2 Nov 2023 19:43:57 -0500
Message-ID: <CAH2r5mtSZGJJYqFK1N+uT5gcr8vkUhLdYNE_VQ3nP67XxnnpPQ@mail.gmail.com>
Subject: Re: [PATCH 11/14] cifs: handle when server starts supporting multichannel
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     nspmangalore@gmail.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000624b5f060934cd82"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000624b5f060934cd82
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

removed cc:stable and changed

> +                             cifs_dbg(VFS, "server %s supports multichan=
nel now\n",
> +                                      ses->server->hostname);

to`

+                               cifs_server_dbg(VFS, "supports
multichannel now\n");

Let me know if that is ok for you.  (See attached updated patch)


On Thu, Nov 2, 2023 at 3:28=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> nspmangalore@gmail.com writes:
>
> > @@ -307,17 +308,41 @@ smb2_reconnect(__le16 smb2_command, struct cifs_t=
con *tcon,
> >               tcon->need_reopen_files =3D true;
> >
> >       rc =3D cifs_tree_connect(0, tcon, nls_codepage);
> > -     mutex_unlock(&ses->session_mutex);
> >
> >       cifs_dbg(FYI, "reconnect tcon rc =3D %d\n", rc);
> >       if (rc) {
> >               /* If sess reconnected but tcon didn't, something strange=
 ... */
> > +             mutex_unlock(&ses->session_mutex);
> >               cifs_dbg(VFS, "reconnect tcon failed rc =3D %d\n", rc);
> >               goto out;
> >       }
> >
> > -     if (smb2_command !=3D SMB2_INTERNAL_CMD)
> > -             mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
> > +     if (!rc &&
> > +         (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
> > +             mutex_unlock(&ses->session_mutex);
> > +
> > +             /*
> > +              * query server network interfaces, in case they change
> > +              */
> > +             xid =3D get_xid();
> > +             rc =3D SMB3_request_interfaces(xid, tcon, false);
> > +             free_xid(xid);
> > +
> > +             if (rc)
> > +                     cifs_dbg(FYI, "%s: failed to query server interfa=
ces: %d\n",
> > +                              __func__, rc);
> > +
> > +             if (ses->chan_max > ses->chan_count &&
> > +                 !SERVER_IS_CHAN(server)) {
> > +                     if (ses->chan_count =3D=3D 1)
> > +                             cifs_dbg(VFS, "server %s supports multich=
annel now\n",
> > +                                      ses->server->hostname);
>
> Sorry, forgot to mention that you should call cifs_dbg_server() which
> protects access of @server->hostname as cifsd thread could have it freed
> before you access it.



--
Thanks,

Steve

--000000000000624b5f060934cd82
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-handle-when-server-starts-supporting-multichann.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-handle-when-server-starts-supporting-multichann.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lohw76ur0>
X-Attachment-Id: f_lohw76ur0

RnJvbSBkMDEyZDg5YzkwYTQ3ZjEyNTA5NTZlZjJkOWI1MTU5MjdiY2M0ZWM5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBNb24sIDMwIE9jdCAyMDIzIDExOjAwOjE3ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogaGFuZGxlIHdoZW4gc2VydmVyIHN0YXJ0cyBzdXBwb3J0aW5nIG11bHRpY2hhbm5lbAoK
V2hlbiB0aGUgdXNlciBtb3VudHMgd2l0aCBtdWx0aWNoYW5uZWwgb3B0aW9uLCBidXQgdGhlCnNl
cnZlciBkb2VzIG5vdCBzdXBwb3J0IGl0LCB0aGVyZSBjYW4gYmUgYSB0aW1lIGluIGZ1dHVyZQp3
aGVyZSBpdCBjYW4gYmUgc3VwcG9ydGVkLgoKV2l0aCB0aGlzIGNoYW5nZSwgc3VjaCBhIGNhc2Ug
aXMgaGFuZGxlZC4KClNpZ25lZC1vZmYtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jv
c29mdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0
LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2NpZnNwcm90by5oIHwgIDQgKysrKwogZnMvc21iL2Ns
aWVudC9jb25uZWN0LmMgICB8ICA2ICsrKysrLQogZnMvc21iL2NsaWVudC9zbWIycGR1LmMgICB8
IDMwICsrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLQogMyBmaWxlcyBjaGFuZ2VkLCAzNiBp
bnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQv
Y2lmc3Byb3RvLmggYi9mcy9zbWIvY2xpZW50L2NpZnNwcm90by5oCmluZGV4IDg5MGNlZGRhZTA3
ZS4uYmIzYmYzY2FjODI4IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNwcm90by5oCisr
KyBiL2ZzL3NtYi9jbGllbnQvY2lmc3Byb3RvLmgKQEAgLTEzMiw2ICsxMzIsMTAgQEAgZXh0ZXJu
IGludCBTZW5kUmVjZWl2ZUJsb2NraW5nTG9jayhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLAogCQkJ
c3RydWN0IHNtYl9oZHIgKmluX2J1ZiwKIAkJCXN0cnVjdCBzbWJfaGRyICpvdXRfYnVmLAogCQkJ
aW50ICpieXRlc19yZXR1cm5lZCk7CisKK3ZvaWQKK3NtYjJfcXVlcnlfc2VydmVyX2ludGVyZmFj
ZXMoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsKKwogdm9pZAogY2lmc19zaWduYWxfY2lmc2Rf
Zm9yX3JlY29ubmVjdChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiAJCQkJICAgICAg
Ym9vbCBhbGxfY2hhbm5lbHMpOwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jb25uZWN0LmMg
Yi9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYwppbmRleCA2Yzc3MDE0MjJkNGMuLjZkNmUzMzRhMDc5
YiAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jb25uZWN0LmMKKysrIGIvZnMvc21iL2NsaWVu
dC9jb25uZWN0LmMKQEAgLTExNiw3ICsxMTYsOCBAQCBzdGF0aWMgaW50IHJlY29ubl9zZXRfaXBh
ZGRyX2Zyb21faG9zdG5hbWUoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCXJldHVy
biByYzsKIH0KIAotc3RhdGljIHZvaWQgc21iMl9xdWVyeV9zZXJ2ZXJfaW50ZXJmYWNlcyhzdHJ1
Y3Qgd29ya19zdHJ1Y3QgKndvcmspCit2b2lkCitzbWIyX3F1ZXJ5X3NlcnZlcl9pbnRlcmZhY2Vz
KHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIHsKIAlpbnQgcmM7CiAJaW50IHhpZDsKQEAgLTEz
NCw2ICsxMzUsOSBAQCBzdGF0aWMgdm9pZCBzbWIyX3F1ZXJ5X3NlcnZlcl9pbnRlcmZhY2VzKHN0
cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAlpZiAocmMpIHsKIAkJY2lmc19kYmcoRllJLCAiJXM6
IGZhaWxlZCB0byBxdWVyeSBzZXJ2ZXIgaW50ZXJmYWNlczogJWRcbiIsCiAJCQkJX19mdW5jX18s
IHJjKTsKKworCQlpZiAocmMgPT0gLUVPUE5PVFNVUFApCisJCQlyZXR1cm47CiAJfQogCiAJcXVl
dWVfZGVsYXllZF93b3JrKGNpZnNpb2Rfd3EsICZ0Y29uLT5xdWVyeV9pbnRlcmZhY2VzLApkaWZm
IC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIycGR1LmMgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUu
YwppbmRleCBjNzVhODBiYjZkOWUuLjNhMTY1MTc3MjQ4NiAxMDA2NDQKLS0tIGEvZnMvc21iL2Ns
aWVudC9zbWIycGR1LmMKKysrIGIvZnMvc21iL2NsaWVudC9zbWIycGR1LmMKQEAgLTE2Myw2ICsx
NjMsNyBAQCBzbWIyX3JlY29ubmVjdChfX2xlMTYgc21iMl9jb21tYW5kLCBzdHJ1Y3QgY2lmc190
Y29uICp0Y29uLAogCWludCByYyA9IDA7CiAJc3RydWN0IG5sc190YWJsZSAqbmxzX2NvZGVwYWdl
ID0gTlVMTDsKIAlzdHJ1Y3QgY2lmc19zZXMgKnNlczsKKwlpbnQgeGlkOwogCiAJLyoKIAkgKiBT
TUIycyBOZWdQcm90LCBTZXNzU2V0dXAsIExvZ29mZiBkbyBub3QgaGF2ZSB0Y29uIHlldCBzbwpA
QCAtMzA3LDE3ICszMDgsNDAgQEAgc21iMl9yZWNvbm5lY3QoX19sZTE2IHNtYjJfY29tbWFuZCwg
c3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJdGNvbi0+bmVlZF9yZW9wZW5fZmlsZXMgPSB0cnVl
OwogCiAJcmMgPSBjaWZzX3RyZWVfY29ubmVjdCgwLCB0Y29uLCBubHNfY29kZXBhZ2UpOwotCW11
dGV4X3VubG9jaygmc2VzLT5zZXNzaW9uX211dGV4KTsKIAogCWNpZnNfZGJnKEZZSSwgInJlY29u
bmVjdCB0Y29uIHJjID0gJWRcbiIsIHJjKTsKIAlpZiAocmMpIHsKIAkJLyogSWYgc2VzcyByZWNv
bm5lY3RlZCBidXQgdGNvbiBkaWRuJ3QsIHNvbWV0aGluZyBzdHJhbmdlIC4uLiAqLworCQltdXRl
eF91bmxvY2soJnNlcy0+c2Vzc2lvbl9tdXRleCk7CiAJCWNpZnNfZGJnKFZGUywgInJlY29ubmVj
dCB0Y29uIGZhaWxlZCByYyA9ICVkXG4iLCByYyk7CiAJCWdvdG8gb3V0OwogCX0KIAotCWlmIChz
bWIyX2NvbW1hbmQgIT0gU01CMl9JTlRFUk5BTF9DTUQpCi0JCW1vZF9kZWxheWVkX3dvcmsoY2lm
c2lvZF93cSwgJnNlcnZlci0+cmVjb25uZWN0LCAwKTsKKwlpZiAoIXJjICYmCisJICAgIChzZXJ2
ZXItPmNhcGFiaWxpdGllcyAmIFNNQjJfR0xPQkFMX0NBUF9NVUxUSV9DSEFOTkVMKSkgeworCQlt
dXRleF91bmxvY2soJnNlcy0+c2Vzc2lvbl9tdXRleCk7CisKKwkJLyoKKwkJICogcXVlcnkgc2Vy
dmVyIG5ldHdvcmsgaW50ZXJmYWNlcywgaW4gY2FzZSB0aGV5IGNoYW5nZQorCQkgKi8KKwkJeGlk
ID0gZ2V0X3hpZCgpOworCQlyYyA9IFNNQjNfcmVxdWVzdF9pbnRlcmZhY2VzKHhpZCwgdGNvbiwg
ZmFsc2UpOworCQlmcmVlX3hpZCh4aWQpOworCisJCWlmIChyYykKKwkJCWNpZnNfZGJnKEZZSSwg
IiVzOiBmYWlsZWQgdG8gcXVlcnkgc2VydmVyIGludGVyZmFjZXM6ICVkXG4iLAorCQkJCSBfX2Z1
bmNfXywgcmMpOworCisJCWlmIChzZXMtPmNoYW5fbWF4ID4gc2VzLT5jaGFuX2NvdW50ICYmCisJ
CSAgICAhU0VSVkVSX0lTX0NIQU4oc2VydmVyKSkgeworCQkJaWYgKHNlcy0+Y2hhbl9jb3VudCA9
PSAxKQorCQkJCWNpZnNfc2VydmVyX2RiZyhWRlMsICJzdXBwb3J0cyBtdWx0aWNoYW5uZWwgbm93
XG4iKTsKKworCQkJY2lmc190cnlfYWRkaW5nX2NoYW5uZWxzKHRjb24tPmNpZnNfc2IsIHNlcyk7
CisJCX0KKwl9IGVsc2UgeworCQltdXRleF91bmxvY2soJnNlcy0+c2Vzc2lvbl9tdXRleCk7CisJ
fQogCiAJYXRvbWljX2luYygmdGNvbkluZm9SZWNvbm5lY3RDb3VudCk7CiBvdXQ6Ci0tIAoyLjM5
LjIKCg==
--000000000000624b5f060934cd82--
