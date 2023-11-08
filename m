Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF0434CF3
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 18:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z4c+ozNO"
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433511FF5
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 10:16:31 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-50949b7d7ffso9690418e87.0
        for <linux-cifs@vger.kernel.org>; Wed, 08 Nov 2023 10:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699467389; x=1700072189; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VFRZOzw6CM3XTef4/+O34BNTF6c+zdFzT8nMTOJzFuQ=;
        b=Z4c+ozNOBBHgEixXMbQ3pPqZFIZHcM1OA4aDDbf4mIUdrpVBtgxvlqkRJxm9thnOll
         2UIcdpMPzkkiOEJYfyOmZiWvon66yD9yN8RBgkaou9VYU/5YZI7jnIwnGTaqYoCW482d
         F/Hx+UOgGbNNGuBRKA9pe2nosEtpPgEWrfZ9mXBdFCL2gz/L5QJC4rdGvYLL6t5+VhFZ
         IxpRf7fulwzZYBhgPOgGZDkBxD0xm7ZDpoWM1MEXeAJ1GOlKIf/vjjK1KyM/CnEKP5Ep
         38Fid272Y99G+ulVCjpUYJohLFYd1/gGUG7Sv7LR0A1zfkwi3bMvt7jVBVEW9X/VC2/Y
         8LBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699467389; x=1700072189;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VFRZOzw6CM3XTef4/+O34BNTF6c+zdFzT8nMTOJzFuQ=;
        b=uZzsKQU2mcttDN2rdFKkVAKTXgeXt+D6xJhUMbBwlC8Q2AdQpGsfThtlgWHFDgvMA9
         syzQalibjHaDtsP3LegxZBg/lWz/RlxmfG7PhY2uNZ0oUJHj2x+QDCzyQspi2RNsO01M
         7HE6Kim8BUD4J7GjAMi1BNs1kDUwEQwT4Nd2kRodAu482ye0C9IrH5Os1qX13aiczEbA
         5kRarxFaPwaExXBIsXITahFAVTC7qiiraAIfZgpb8oh/riJCrQzMQAbeS9ZlzTI9xRcE
         F1lDfQcEzDyD1HNre5zcgOJTj9NubuaRUmkwXHq7Po/M1WdH8qNIyTNTeFQUOogEU5uk
         Fi5w==
X-Gm-Message-State: AOJu0YynE2HmodgiA0JDHRLh4tnmK58UKqX7OsnClOhrckbjPX41hZSh
	TxKAT65TDTDQChAH+02JKgMWhB3ryfpKmnfyopG4H9IBlw6fMA==
X-Google-Smtp-Source: AGHT+IFJdH3csPZzcwG26Jwix/ttdC74n+mIFvh5EFeAfwBdznbzJoIU0c/LSsnVmIexKDM/c+1dJ65CffT425nxBOM=
X-Received: by 2002:ac2:5292:0:b0:507:9702:c11d with SMTP id
 q18-20020ac25292000000b005079702c11dmr1851488lfm.64.1699467389054; Wed, 08
 Nov 2023 10:16:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-8-sprasad@microsoft.com>
 <efd21d30cc8b110347931c98fb21db62.pc@manguebit.com>
In-Reply-To: <efd21d30cc8b110347931c98fb21db62.pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 8 Nov 2023 12:16:17 -0600
Message-ID: <CAH2r5msjbq_g8NRr1ctfmkWsTs9-G3zPVrt7-Jm4g44jeeks4A@mail.gmail.com>
Subject: Re: [PATCH 08/14] cifs: account for primary channel in the interface list
To: Paulo Alcantara <pc@manguebit.com>
Cc: nspmangalore@gmail.com, bharathsm.hsk@gmail.com, 
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000084f720609a816f2"

--000000000000084f720609a816f2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Updated patch attached. Let me know if any objections.

Paulo,
I made minor updates to Shyam's patch following your suggestion of
changing the logging level you suggested, and saving off dstaddr so we
don't have to hold a lock on it

On Wed, Nov 8, 2023 at 9:44=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> nspmangalore@gmail.com writes:
>
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > The refcounting of server interfaces should account
> > for the primary channel too. Although this is not
> > strictly necessary, doing so will account for the primary
> > channel in DebugData.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/sess.c    | 23 +++++++++++++++++++++++
> >  fs/smb/client/smb2ops.c |  6 ++++++
> >  2 files changed, 29 insertions(+)
> >
> > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > index d009994f82cf..6843deed6119 100644
> > --- a/fs/smb/client/sess.c
> > +++ b/fs/smb/client/sess.c
> > @@ -332,6 +332,16 @@ cifs_chan_update_iface(struct cifs_ses *ses, struc=
t TCP_Server_Info *server)
> >
> >       /* then look for a new one */
> >       list_for_each_entry(iface, &ses->iface_list, iface_head) {
> > +             if (!chan_index) {
> > +                     /* if we're trying to get the updated iface for p=
rimary channel */
> > +                     if (!cifs_match_ipaddr((struct sockaddr *) &serve=
r->dstaddr,
> > +                                            (struct sockaddr *) &iface=
->sockaddr))
> > +                             continue;
>
> You should hold @server->srv_lock to protect access of @server->dstaddr
> as it might change over reconnect or mount.
>
> > +
> > +                     kref_get(&iface->refcount);
> > +                     break;
> > +             }
> > +
> >               /* do not mix rdma and non-rdma interfaces */
> >               if (iface->rdma_capable !=3D server->rdma)
> >                       continue;
> > @@ -358,6 +368,13 @@ cifs_chan_update_iface(struct cifs_ses *ses, struc=
t TCP_Server_Info *server)
> >               cifs_dbg(FYI, "unable to find a suitable iface\n");
> >       }
> >
> > +     if (!chan_index && !iface) {
> > +             cifs_dbg(VFS, "unable to get the interface matching: %pIS=
\n",
> > +                      &server->dstaddr);
>
> Ditto.
>
> Also, I think you should log in FYI level as the above doesn't seem
> unlikely to happen.



--=20
Thanks,

Steve

--000000000000084f720609a816f2
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-account-for-primary-channel-in-the-interface-li.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-account-for-primary-channel-in-the-interface-li.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_loq2zv4i0>
X-Attachment-Id: f_loq2zv4i0

RnJvbSA4MDIzY2IzY2ExNTU1NTFhYmNlZjcxMjVjZDUzZTYyNjAyMmZjNTNiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUdWUsIDE0IE1hciAyMDIzIDExOjE0OjU4ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogYWNjb3VudCBmb3IgcHJpbWFyeSBjaGFubmVsIGluIHRoZSBpbnRlcmZhY2UgbGlzdAoK
VGhlIHJlZmNvdW50aW5nIG9mIHNlcnZlciBpbnRlcmZhY2VzIHNob3VsZCBhY2NvdW50CmZvciB0
aGUgcHJpbWFyeSBjaGFubmVsIHRvby4gQWx0aG91Z2ggdGhpcyBpcyBub3QKc3RyaWN0bHkgbmVj
ZXNzYXJ5LCBkb2luZyBzbyB3aWxsIGFjY291bnQgZm9yIHRoZSBwcmltYXJ5CmNoYW5uZWwgaW4g
RGVidWdEYXRhLgoKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKU2lnbmVkLW9mZi1ieTogU2h5
YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUg
RnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvc2Vzcy5j
ICAgIHwgMjggKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogZnMvc21iL2NsaWVudC9zbWIy
b3BzLmMgfCAgNiArKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMzQgaW5zZXJ0aW9ucygrKQoKZGlm
ZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc2Vzcy5jIGIvZnMvc21iL2NsaWVudC9zZXNzLmMKaW5k
ZXggMDRkMzAwZTlhNzc5Li4yMWU3NWNhNDcxNTEgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQv
c2Vzcy5jCisrKyBiL2ZzL3NtYi9jbGllbnQvc2Vzcy5jCkBAIC0zMDMsNiArMzAzLDcgQEAgY2lm
c19jaGFuX3VwZGF0ZV9pZmFjZShzdHJ1Y3QgY2lmc19zZXMgKnNlcywgc3RydWN0IFRDUF9TZXJ2
ZXJfSW5mbyAqc2VydmVyKQogCXN0cnVjdCBjaWZzX3NlcnZlcl9pZmFjZSAqaWZhY2UgPSBOVUxM
OwogCXN0cnVjdCBjaWZzX3NlcnZlcl9pZmFjZSAqb2xkX2lmYWNlID0gTlVMTDsKIAlzdHJ1Y3Qg
Y2lmc19zZXJ2ZXJfaWZhY2UgKmxhc3RfaWZhY2UgPSBOVUxMOworCXN0cnVjdCBzb2NrYWRkcl9z
dG9yYWdlIHNzOwogCWludCByYyA9IDA7CiAKIAlzcGluX2xvY2soJnNlcy0+Y2hhbl9sb2NrKTsK
QEAgLTMyMSw2ICszMjIsMTAgQEAgY2lmc19jaGFuX3VwZGF0ZV9pZmFjZShzdHJ1Y3QgY2lmc19z
ZXMgKnNlcywgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCX0KIAlzcGluX3VubG9j
aygmc2VzLT5jaGFuX2xvY2spOwogCisJc3Bpbl9sb2NrKCZzZXJ2ZXItPnNydl9sb2NrKTsKKwlz
cyA9IHNlcnZlci0+ZHN0YWRkcjsKKwlzcGluX3VubG9jaygmc2VydmVyLT5zcnZfbG9jayk7CisK
IAlzcGluX2xvY2soJnNlcy0+aWZhY2VfbG9jayk7CiAJaWYgKCFzZXMtPmlmYWNlX2NvdW50KSB7
CiAJCXNwaW5fdW5sb2NrKCZzZXMtPmlmYWNlX2xvY2spOwpAQCAtMzM0LDYgKzMzOSwxNiBAQCBj
aWZzX2NoYW5fdXBkYXRlX2lmYWNlKHN0cnVjdCBjaWZzX3NlcyAqc2VzLCBzdHJ1Y3QgVENQX1Nl
cnZlcl9JbmZvICpzZXJ2ZXIpCiAKIAkvKiB0aGVuIGxvb2sgZm9yIGEgbmV3IG9uZSAqLwogCWxp
c3RfZm9yX2VhY2hfZW50cnkoaWZhY2UsICZzZXMtPmlmYWNlX2xpc3QsIGlmYWNlX2hlYWQpIHsK
KwkJaWYgKCFjaGFuX2luZGV4KSB7CisJCQkvKiBpZiB3ZSdyZSB0cnlpbmcgdG8gZ2V0IHRoZSB1
cGRhdGVkIGlmYWNlIGZvciBwcmltYXJ5IGNoYW5uZWwgKi8KKwkJCWlmICghY2lmc19tYXRjaF9p
cGFkZHIoKHN0cnVjdCBzb2NrYWRkciAqKSAmc3MsCisJCQkJCSAgICAgICAoc3RydWN0IHNvY2th
ZGRyICopICZpZmFjZS0+c29ja2FkZHIpKQorCQkJCWNvbnRpbnVlOworCisJCQlrcmVmX2dldCgm
aWZhY2UtPnJlZmNvdW50KTsKKwkJCWJyZWFrOworCQl9CisKIAkJLyogZG8gbm90IG1peCByZG1h
IGFuZCBub24tcmRtYSBpbnRlcmZhY2VzICovCiAJCWlmIChpZmFjZS0+cmRtYV9jYXBhYmxlICE9
IHNlcnZlci0+cmRtYSkKIAkJCWNvbnRpbnVlOwpAQCAtMzYwLDYgKzM3NSwxMyBAQCBjaWZzX2No
YW5fdXBkYXRlX2lmYWNlKHN0cnVjdCBjaWZzX3NlcyAqc2VzLCBzdHJ1Y3QgVENQX1NlcnZlcl9J
bmZvICpzZXJ2ZXIpCiAJCWNpZnNfZGJnKEZZSSwgInVuYWJsZSB0byBmaW5kIGEgc3VpdGFibGUg
aWZhY2VcbiIpOwogCX0KIAorCWlmICghY2hhbl9pbmRleCAmJiAhaWZhY2UpIHsKKwkJY2lmc19k
YmcoRllJLCAidW5hYmxlIHRvIGdldCB0aGUgaW50ZXJmYWNlIG1hdGNoaW5nOiAlcElTXG4iLAor
CQkJICZzcyk7CisJCXNwaW5fdW5sb2NrKCZzZXMtPmlmYWNlX2xvY2spOworCQlyZXR1cm4gMDsK
Kwl9CisKIAkvKiBub3cgZHJvcCB0aGUgcmVmIHRvIHRoZSBjdXJyZW50IGlmYWNlICovCiAJaWYg
KG9sZF9pZmFjZSAmJiBpZmFjZSkgewogCQljaWZzX2RiZyhGWUksICJyZXBsYWNpbmcgaWZhY2U6
ICVwSVMgd2l0aCAlcElTXG4iLApAQCAtMzgyLDYgKzQwNCwxMiBAQCBjaWZzX2NoYW5fdXBkYXRl
X2lmYWNlKHN0cnVjdCBjaWZzX3NlcyAqc2VzLCBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2
ZXIpCiAJCQlvbGRfaWZhY2UtPndlaWdodF9mdWxmaWxsZWQtLTsKIAogCQlrcmVmX3B1dCgmb2xk
X2lmYWNlLT5yZWZjb3VudCwgcmVsZWFzZV9pZmFjZSk7CisJfSBlbHNlIGlmICghY2hhbl9pbmRl
eCkgeworCQkvKiBzcGVjaWFsIGNhc2U6IHVwZGF0ZSBpbnRlcmZhY2UgZm9yIHByaW1hcnkgY2hh
bm5lbCAqLworCQljaWZzX2RiZyhGWUksICJyZWZlcmVuY2luZyBwcmltYXJ5IGNoYW5uZWwgaWZh
Y2U6ICVwSVNcbiIsCisJCQkgJmlmYWNlLT5zb2NrYWRkcik7CisJCWlmYWNlLT5udW1fY2hhbm5l
bHMrKzsKKwkJaWZhY2UtPndlaWdodF9mdWxmaWxsZWQrKzsKIAl9IGVsc2UgewogCQlXQVJOX09O
KCFpZmFjZSk7CiAJCWNpZnNfZGJnKEZZSSwgImFkZGluZyBuZXcgaWZhY2U6ICVwSVNcbiIsICZp
ZmFjZS0+c29ja2FkZHIpOwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIyb3BzLmMgYi9m
cy9zbWIvY2xpZW50L3NtYjJvcHMuYwppbmRleCA2MDFlN2ExODdmODcuLmE5NTllZDJjOWIyMiAx
MDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zbWIyb3BzLmMKKysrIGIvZnMvc21iL2NsaWVudC9z
bWIyb3BzLmMKQEAgLTc1Niw2ICs3NTYsNyBAQCBTTUIzX3JlcXVlc3RfaW50ZXJmYWNlcyhjb25z
dCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBib29sIGluXwogCXVu
c2lnbmVkIGludCByZXRfZGF0YV9sZW4gPSAwOwogCXN0cnVjdCBuZXR3b3JrX2ludGVyZmFjZV9p
bmZvX2lvY3RsX3JzcCAqb3V0X2J1ZiA9IE5VTEw7CiAJc3RydWN0IGNpZnNfc2VzICpzZXMgPSB0
Y29uLT5zZXM7CisJc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqcHNlcnZlcjsKIAogCS8qIGRvIG5v
dCBxdWVyeSB0b28gZnJlcXVlbnRseSAqLwogCWlmIChzZXMtPmlmYWNlX2xhc3RfdXBkYXRlICYm
CkBAIC03ODAsNiArNzgxLDExIEBAIFNNQjNfcmVxdWVzdF9pbnRlcmZhY2VzKGNvbnN0IHVuc2ln
bmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIGJvb2wgaW5fCiAJaWYgKHJjKQog
CQlnb3RvIG91dDsKIAorCS8qIGNoZWNrIGlmIGlmYWNlIGlzIHN0aWxsIGFjdGl2ZSAqLworCXBz
ZXJ2ZXIgPSBzZXMtPmNoYW5zWzBdLnNlcnZlcjsKKwlpZiAocHNlcnZlciAmJiAhY2lmc19jaGFu
X2lzX2lmYWNlX2FjdGl2ZShzZXMsIHBzZXJ2ZXIpKQorCQljaWZzX2NoYW5fdXBkYXRlX2lmYWNl
KHNlcywgcHNlcnZlcik7CisKIG91dDoKIAlrZnJlZShvdXRfYnVmKTsKIAlyZXR1cm4gcmM7Ci0t
IAoyLjM5LjIKCg==
--000000000000084f720609a816f2--
