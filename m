Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259B037143
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 19:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VN69BQdT"
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F982110
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 11:25:39 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-507cee17b00so14398e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 08 Nov 2023 11:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699471537; x=1700076337; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LEZeLPt8VF+PrqyWgs615LFDEQTzzfQMn1/zB7Qo18c=;
        b=VN69BQdTcXHRrGloWPhP3zXKyPymhWoDda6UKzvE2ut2BMpoQscNbvwoP6Q4p1Egbc
         2chom3iiKpYzSUtmlFG1zaSTZdliC6HmxVtNw0UPc5NW3rreiin0AsWVL3zM9ZBcc+ph
         snrD+oDX8lcvTg0G2Z4UrSQ9FJ0Hl5PrbUXWTDueSD22uYWNkOjI+/YipKhAx+IS5c8C
         gUqW6NopdXBDAvO8X6vYXGl2VOjoXkJPM4ZXR2NojsrZTocymuimbPahSeksPrFfs38o
         SxLDjUiyLIF28dv3uqO7zPFVfRiHcwLnDZq4mjf2OVhE23NsVFU/7BHwiGtw3tlscgBe
         9kzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699471537; x=1700076337;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LEZeLPt8VF+PrqyWgs615LFDEQTzzfQMn1/zB7Qo18c=;
        b=w3WEKaWdgFT0wshk2XXC7+lzRVPXDyHOMJLy7NyWzpGYPNDdwYoxNXqVkrl/w0EQVH
         r4fUfek9Saq8mzc2sy+Ye72xbN0cILM5U0LEnP6SOHyNEv5OJzk4fHOV279Fs39aHBG0
         qlQM5XVH4GRdApJxZW5bIQ40xZz/U6jI2PvbdMpf3u5LC/JDdbUINU3/yLNyZFy6CM6x
         oBQq3o4fPblWVd8sv9t4hXVSe0w/mmY9S+WE3HFj1FRiy4TyWIe0ng5k/SpUyTa8kRhm
         cR542PjO8RDL+QXC7fgp7vQYFLmnj9NOKiaxKsMJtPlFMeFpVzPz6fsFiGah0WPxKRSQ
         xfdQ==
X-Gm-Message-State: AOJu0YxmfscMhrRdJjutFZj54hXEkSqKHg1fKizCY9o0r6NkyAoscY1W
	Za0y/7bRxf3BqGrCNUUHaSYv8vU0v07/HU4gIug=
X-Google-Smtp-Source: AGHT+IHwos17PRhydF7R9w8UrgTGOAbayZ8GvvnPfT/eIGDngOB6S7cUZT6t4qaL+blug6B3dPgfjHa+F2AR6Dzp44M=
X-Received: by 2002:a05:6512:a84:b0:507:984e:9f17 with SMTP id
 m4-20020a0565120a8400b00507984e9f17mr2260898lfu.34.1699471537343; Wed, 08 Nov
 2023 11:25:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-11-sprasad@microsoft.com>
 <b709f32a96f04ff6136b69605788a2e6.pc@manguebit.com> <CAH2r5mtSZGJJYqFK1N+uT5gcr8vkUhLdYNE_VQ3nP67XxnnpPQ@mail.gmail.com>
 <5deda9f23865fafcbd99d57424791138.pc@manguebit.com>
In-Reply-To: <5deda9f23865fafcbd99d57424791138.pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 8 Nov 2023 13:25:26 -0600
Message-ID: <CAH2r5mvAYAJKGvG-Jm42L-5EG6CYxVS4bNs1y_+0477RO2e20Q@mail.gmail.com>
Subject: Re: [PATCH 11/14] cifs: handle when server starts supporting multichannel
To: Paulo Alcantara <pc@manguebit.com>
Cc: nspmangalore@gmail.com, bharathsm.hsk@gmail.com, 
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="0000000000004a29ed0609a90dd7"

--0000000000004a29ed0609a90dd7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I just updated the patch in for-next (see attached)

I removed the unneeded export of smb2_query_server_interfaces() but it
looks like the logging of failed network interface queries is fine
(and is an FYI message so not turned on automatically) - I could
definitely see cases where FYI logging is turned on to see why query
server interfaces failed even in the EOPNOTSUPP case - so the debug
FYI looks ok to me


On Wed, Nov 8, 2023 at 10:02=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Paulo Alcantara <pc@manguebit.com> writes:
>
> > Steve French <smfrench@gmail.com> writes:
> >
> >> removed cc:stable and changed
> >>
> >>> +                             cifs_dbg(VFS, "server %s supports multi=
channel now\n",
> >>> +                                      ses->server->hostname);
> >>
> >> to`
> >>
> >> +                               cifs_server_dbg(VFS, "supports
> >> multichannel now\n");
> >
> > Looks good, thanks.
> >
> >> Let me know if that is ok for you.  (See attached updated patch)
> >
> > For the s/cifs_dbg/cifs_server_dbg/ change, it is.
>
> BTW, this patch in for-next branch still contains
>
>         (1) misleading export of smb2_query_server_interfaces()
>
>         (2) removal of mod_delayed_work() when reconnect failed
>
>         (3) logging of failed network interface queries even when server
>         doesn't support it.
>


--=20
Thanks,

Steve

--0000000000004a29ed0609a90dd7
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-handle-when-server-starts-supporting-multichann.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-handle-when-server-starts-supporting-multichann.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_loq5gola0>
X-Attachment-Id: f_loq5gola0

RnJvbSAwN2EyOTBjOWQyN2JkZWRmYmEzY2YwOTEwNzY4OTY5ZWE1NTMxNTdlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDEzIE9jdCAyMDIzIDExOjMzOjIxICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogaGFuZGxlIHdoZW4gc2VydmVyIHN0YXJ0cyBzdXBwb3J0aW5nIG11bHRpY2hhbm5lbAoK
V2hlbiB0aGUgdXNlciBtb3VudHMgd2l0aCBtdWx0aWNoYW5uZWwgb3B0aW9uLCBidXQgdGhlCnNl
cnZlciBkb2VzIG5vdCBzdXBwb3J0IGl0LCB0aGVyZSBjYW4gYmUgYSB0aW1lIGluIGZ1dHVyZQp3
aGVyZSBpdCBjYW4gYmUgc3VwcG9ydGVkLgoKV2l0aCB0aGlzIGNoYW5nZSwgc3VjaCBhIGNhc2Ug
aXMgaGFuZGxlZC4KClNpZ25lZC1vZmYtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jv
c29mdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0
LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2Nvbm5lY3QuYyB8ICAzICsrKwogZnMvc21iL2NsaWVu
dC9zbWIycGR1LmMgfCAzMCArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0KIDIgZmlsZXMg
Y2hhbmdlZCwgMzAgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9m
cy9zbWIvY2xpZW50L2Nvbm5lY3QuYyBiL2ZzL3NtYi9jbGllbnQvY29ubmVjdC5jCmluZGV4IGI1
MTRiNDFjYzlmMC4uNTVjZjcwODAwYmI1IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2Nvbm5l
Y3QuYworKysgYi9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYwpAQCAtMTM0LDYgKzEzNCw5IEBAIHN0
YXRpYyB2b2lkIHNtYjJfcXVlcnlfc2VydmVyX2ludGVyZmFjZXMoc3RydWN0IHdvcmtfc3RydWN0
ICp3b3JrKQogCWlmIChyYykgewogCQljaWZzX2RiZyhGWUksICIlczogZmFpbGVkIHRvIHF1ZXJ5
IHNlcnZlciBpbnRlcmZhY2VzOiAlZFxuIiwKIAkJCQlfX2Z1bmNfXywgcmMpOworCisJCWlmIChy
YyA9PSAtRU9QTk9UU1VQUCkKKwkJCXJldHVybjsKIAl9CiAKIAlxdWV1ZV9kZWxheWVkX3dvcmso
Y2lmc2lvZF93cSwgJnRjb24tPnF1ZXJ5X2ludGVyZmFjZXMsCmRpZmYgLS1naXQgYS9mcy9zbWIv
Y2xpZW50L3NtYjJwZHUuYyBiL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCmluZGV4IGI3NjY1MTU1
ZjRlMi4uNjU2MzZiZGY2Y2RmIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwor
KysgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwpAQCAtMTYzLDYgKzE2Myw3IEBAIHNtYjJfcmVj
b25uZWN0KF9fbGUxNiBzbWIyX2NvbW1hbmQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJaW50
IHJjID0gMDsKIAlzdHJ1Y3QgbmxzX3RhYmxlICpubHNfY29kZXBhZ2UgPSBOVUxMOwogCXN0cnVj
dCBjaWZzX3NlcyAqc2VzOworCWludCB4aWQ7CiAKIAkvKgogCSAqIFNNQjJzIE5lZ1Byb3QsIFNl
c3NTZXR1cCwgTG9nb2ZmIGRvIG5vdCBoYXZlIHRjb24geWV0IHNvCkBAIC0zMDcsMTcgKzMwOCw0
MCBAQCBzbWIyX3JlY29ubmVjdChfX2xlMTYgc21iMl9jb21tYW5kLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAogCQl0Y29uLT5uZWVkX3Jlb3Blbl9maWxlcyA9IHRydWU7CiAKIAlyYyA9IGNpZnNf
dHJlZV9jb25uZWN0KDAsIHRjb24sIG5sc19jb2RlcGFnZSk7Ci0JbXV0ZXhfdW5sb2NrKCZzZXMt
PnNlc3Npb25fbXV0ZXgpOwogCiAJY2lmc19kYmcoRllJLCAicmVjb25uZWN0IHRjb24gcmMgPSAl
ZFxuIiwgcmMpOwogCWlmIChyYykgewogCQkvKiBJZiBzZXNzIHJlY29ubmVjdGVkIGJ1dCB0Y29u
IGRpZG4ndCwgc29tZXRoaW5nIHN0cmFuZ2UgLi4uICovCisJCW11dGV4X3VubG9jaygmc2VzLT5z
ZXNzaW9uX211dGV4KTsKIAkJY2lmc19kYmcoVkZTLCAicmVjb25uZWN0IHRjb24gZmFpbGVkIHJj
ID0gJWRcbiIsIHJjKTsKIAkJZ290byBvdXQ7CiAJfQogCi0JaWYgKHNtYjJfY29tbWFuZCAhPSBT
TUIyX0lOVEVSTkFMX0NNRCkKLQkJbW9kX2RlbGF5ZWRfd29yayhjaWZzaW9kX3dxLCAmc2VydmVy
LT5yZWNvbm5lY3QsIDApOworCWlmICghcmMgJiYKKwkgICAgKHNlcnZlci0+Y2FwYWJpbGl0aWVz
ICYgU01CMl9HTE9CQUxfQ0FQX01VTFRJX0NIQU5ORUwpKSB7CisJCW11dGV4X3VubG9jaygmc2Vz
LT5zZXNzaW9uX211dGV4KTsKKworCQkvKgorCQkgKiBxdWVyeSBzZXJ2ZXIgbmV0d29yayBpbnRl
cmZhY2VzLCBpbiBjYXNlIHRoZXkgY2hhbmdlCisJCSAqLworCQl4aWQgPSBnZXRfeGlkKCk7CisJ
CXJjID0gU01CM19yZXF1ZXN0X2ludGVyZmFjZXMoeGlkLCB0Y29uLCBmYWxzZSk7CisJCWZyZWVf
eGlkKHhpZCk7CisKKwkJaWYgKHJjKQorCQkJY2lmc19kYmcoRllJLCAiJXM6IGZhaWxlZCB0byBx
dWVyeSBzZXJ2ZXIgaW50ZXJmYWNlczogJWRcbiIsCisJCQkJIF9fZnVuY19fLCByYyk7CisKKwkJ
aWYgKHNlcy0+Y2hhbl9tYXggPiBzZXMtPmNoYW5fY291bnQgJiYKKwkJICAgICFTRVJWRVJfSVNf
Q0hBTihzZXJ2ZXIpKSB7CisJCQlpZiAoc2VzLT5jaGFuX2NvdW50ID09IDEpCisJCQkJY2lmc19z
ZXJ2ZXJfZGJnKFZGUywgInN1cHBvcnRzIG11bHRpY2hhbm5lbCBub3dcbiIpOworCisJCQljaWZz
X3RyeV9hZGRpbmdfY2hhbm5lbHMoc2VzKTsKKwkJfQorCX0gZWxzZSB7CisJCW11dGV4X3VubG9j
aygmc2VzLT5zZXNzaW9uX211dGV4KTsKKwl9CiAKIAlhdG9taWNfaW5jKCZ0Y29uSW5mb1JlY29u
bmVjdENvdW50KTsKIG91dDoKLS0gCjIuMzkuMgoK
--0000000000004a29ed0609a90dd7--
