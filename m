Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E516B1363
	for <linux-cifs@vger.kernel.org>; Fri, 10 Nov 2023 06:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ljzgw6Jl"
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E218F6A7A
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 22:57:33 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-32ddfb38c02so983859f8f.3
        for <linux-cifs@vger.kernel.org>; Thu, 09 Nov 2023 22:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699599452; x=1700204252; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PF+P2ES2usd+ov2SU6hSbpAot5w/PyPGjgiQx0p30xA=;
        b=ljzgw6JlXgmZCxSWJNxfqYVywJL8R94mURn0ZS6JvNya94eU3t7dZRq2TUBlx0H4D9
         bPrvuVq94wEMMPNDHq+46HsCJ6i0DuhK+BUq9thpenK0kwdPjQXdUWc/5cvJGPE6Rog4
         Etyek7/D/oRadI44XLWdkB4E4SIOzcKUZ2DJoroF7ZIFbsYF9KmmfgcdNZQI74ngTbJG
         sW1wOpuAqVl+Y2U4WbCwQ32SF/7aC5QRvKd/Tz4DKvjMT4zZ55KmMMgU2ZFjqqxk7KJX
         Goa79dCOlS3Tl6zf5YbC79WSSA+LvvFWtXtuA+TSpZ4n9gBz764rpmY30HcBFszaeRAf
         MgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699599452; x=1700204252;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PF+P2ES2usd+ov2SU6hSbpAot5w/PyPGjgiQx0p30xA=;
        b=NhjMyziRwWyJM07ByNTYRQaKBP+OtqKk6VZiBzFWgJCdL5njT4g97CdKQErpz5pVq2
         OcQ7stppqp4IIKfdSky8Tp3l63EffK7IPQPf4AX69//faWlU+RuXWpS48MZ+p68pZwv5
         Yk3KO5skgCuMaUtHF8bykshpRSlT6jniuSQYZkGtDkK0pKM0V7CmFqBbbZF2MfbxvAGD
         RSJa9lQ//moQ2is3aCY5WFDUZRdvcJkp/D885RHcBPazyWmwYbY/HejBSzVgtOC1qHXF
         jRCTdcI6v653752tESEbFhNIcAzC80A8BiMg/fD26m4loLna8H+7xEdqFuuooq/ky35L
         06NA==
X-Gm-Message-State: AOJu0YwGaUboQCwPGOLcUhJ//TNr/ZSYQxq+vc6A28oC+Ay6xEy+3JM9
	yCItOISOdxC06xc3JBAo1ZNhp8x63GSKFKQ/BbkQVEsJNV4=
X-Google-Smtp-Source: AGHT+IH5G+hAjz4b6AzhxsD8kS/syp0MWVsozehP0IJkcx+UGTRlfGkCNDmPsMcx1ON3rRsDbWEvBci5dHUK3ROBK5U=
X-Received: by 2002:a05:6512:2088:b0:507:9784:644d with SMTP id
 t8-20020a056512208800b005079784644dmr2797196lfr.15.1699589362011; Thu, 09 Nov
 2023 20:09:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-12-sprasad@microsoft.com>
 <5890a4eec52f50b271ba8188f1ace1c9.pc@manguebit.com> <147809311fa1593993c7852e32fa52fd.pc@manguebit.com>
 <CANT5p=pawpExEBXp93rK-kmoBPRY4QDMiyXvDCv7Ug0_vrxUPQ@mail.gmail.com>
 <abf890046207efea833cf9f5f9d589ab.pc@manguebit.com> <CANT5p=pJ5cXB+U3Zk=V_1Kzt5pkVidmgBZ_rxqmd1-Nisc6-NA@mail.gmail.com>
In-Reply-To: <CANT5p=pJ5cXB+U3Zk=V_1Kzt5pkVidmgBZ_rxqmd1-Nisc6-NA@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 10 Nov 2023 09:39:10 +0530
Message-ID: <CANT5p=p=HC_Bkc57JxE3UDeDXppw7UNecw-iG62v-9GWGnq8Aw@mail.gmail.com>
Subject: Re: [PATCH 12/14] cifs: handle when server stops supporting multichannel
To: Paulo Alcantara <pc@manguebit.com>
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000301cb50609c47c75"

--000000000000301cb50609c47c75
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2023 at 7:19=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.c=
om> wrote:
>
> On Thu, Nov 9, 2023 at 6:58=E2=80=AFPM Paulo Alcantara <pc@manguebit.com>=
 wrote:
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> >
> > > On Thu, Nov 9, 2023 at 1:11=E2=80=AFAM Paulo Alcantara <pc@manguebit.=
com> wrote:
> > >>
> > >> > and leaked server connections
> > >> >
> > >> >       Display Internal CIFS Data Structures for Debugging
> > >> >       ---------------------------------------------------
> > >> >       CIFS Version 2.46
> > >> >       Features: DFS,FSCACHE,STATS2,DEBUG2,ALLOW_INSECURE_LEGACY,CI=
FS_POSIX,UPCALL(SPNEGO),XATTR,ACL,WITNESS
> > >> >       CIFSMaxBufSize: 16384
> > >> >       Active VFS Requests: 0
> > >> >
> > >> >       Servers:
> > >> >       1) ConnectionId: 0x70e Hostname: w22-root2.gandalf.test
> > >> >       ClientGUID: 44DAE383-3E91-3042-85FE-87D6F17298B7
> > >> >       Number of credits: 1,1,1 Dialect 0x210
> > >> >       Server capabilities: 0x300007
> > >> >       TCP status: 4 Instance: 77
> > >> >       Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net nam=
espace: 4026531840
> > >> >       In Send: 0 In MaxReq Wait: 0
> > >> >       DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link10
> > >> >
> > >> >               Sessions:
> > >> >                       [NONE]
> > >> >       2) ConnectionId: 0x706 Hostname: w22-root2.gandalf.test
> > >> >       ClientGUID: C8CF45E4-F70D-DF40-8821-0234A2E20DD4
> > >> >       Number of credits: 1,1,1 Dialect 0x210
> > >> >       Server capabilities: 0x300007
> > >> >       TCP status: 4 Instance: 81
> > >> >       Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net nam=
espace: 4026531840
> > >> >       In Send: 0 In MaxReq Wait: 0
> > >> >       DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link6
> > >> >
> > >> >               Sessions:
> > >> >                       [NONE]
> > >> >       3) ConnectionId: 0x6ae Hostname: w22-root1.gandalf.test
> > >> >       ClientGUID: AB059CDD-12FF-B94D-B30C-9E1928ACBA95
> > >> >       Number of credits: 1,1,1 Dialect 0x210
> > >> >       Server capabilities: 0x300007
> > >> >       TCP status: 4 Instance: 96
> > >> >       Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net nam=
espace: 4026531840
> > >> >       In Send: 0 In MaxReq Wait: 0
> > >> >       DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link9
> > >> >
> > >> >               Sessions:
> > >> >                       [NONE]
> > >> >         ...
> > >>
> > >> I ended up with a simple reproducer for the above
> > >>
> > >>         mount.cifs //srv/share /mnt/1 -o ...,echo_interval=3D10
> > >>         iptables -I INPUT -s $srvaddr -j DROP
> > >>         stat -f /mnt/1
> > >>         # check dmesg for "BUG: sleeping function called from invali=
d context"
> > >>         iptables -I INPUT -s $srvaddr -j ACCEPT
> > >>         stat -f /mnt/1
> > >>         umount /mnt/1
> > >>         # check /proc/fs/cifs/DebugData for leaked server connection
> > >
> > > Ack. I'll try and get a repro locally and debug this one.
> >
> > This should be related to patch 10/14 as you're taking an extra
> > reference of @server over reconnect, and when the client reconnects and
> > umount, that reference don't seem to be put afterwards.
>
> The idea is that the reference is put in the reconnect worker.
> I think the issue is that I don't drop the final reference if
> cancel_delayed_work_sync was able to cancel a work.
This was already taken care of.

> Let me work on the updated patch.
>
> Also, I found the reason for "BUG: sleeping function called from
> invalid context". I've enabled CONFIG_DEBUG_ATOMIC_SLEEP in my test
> config now.
>
> --
> Regards,
> Shyam

Hi Paulo,

Can you please check if the problem is still seen with these updated patche=
s?
I was unable to reproduce the issue with the steps you provided.

--=20
Regards,
Shyam

--000000000000301cb50609c47c75
Content-Type: application/octet-stream; 
	name="0007-cifs-handle-when-server-stops-supporting-multichanne.patch"
Content-Disposition: attachment; 
	filename="0007-cifs-handle-when-server-stops-supporting-multichanne.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_los3lgdy0>
X-Attachment-Id: f_los3lgdy0

RnJvbSA1MTA2MDg2NDczMTI0MTY3ZTllMGJkY2Q1ODk1YzJmNDhlNWViODE2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDEzIE9jdCAyMDIzIDExOjQwOjA5ICswMDAwClN1YmplY3Q6IFtQQVRDSCA3
LzldIGNpZnM6IGhhbmRsZSB3aGVuIHNlcnZlciBzdG9wcyBzdXBwb3J0aW5nIG11bHRpY2hhbm5l
bAoKV2hlbiBhIHNlcnZlciBzdG9wcyBzdXBwb3J0aW5nIG11bHRpY2hhbm5lbCwgd2Ugd2lsbApr
ZWVwIGF0dGVtcHRpbmcgcmVjb25uZWN0cyB0byB0aGUgc2Vjb25kYXJ5IGNoYW5uZWxzIHRvZGF5
LgpBdm9pZCB0aGlzIGJ5IGZyZWVpbmcgZXh0cmEgY2hhbm5lbHMgd2hlbiBuZWdvdGlhdGUKcmV0
dXJucyBubyBtdWx0aWNoYW5uZWwgc3VwcG9ydC4KClNpZ25lZC1vZmYtYnk6IFNoeWFtIFByYXNh
ZCBOIDxzcHJhc2FkQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5o
ICB8ICAxICsKIGZzL3NtYi9jbGllbnQvY2lmc3Byb3RvLmggfCAgMiArKwogZnMvc21iL2NsaWVu
dC9jb25uZWN0LmMgICB8IDEwICsrKysrKwogZnMvc21iL2NsaWVudC9zZXNzLmMgICAgICB8IDY0
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLQogZnMvc21iL2NsaWVudC9zbWIycGR1
LmMgICB8IDc2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQogZnMvc21i
L2NsaWVudC90cmFuc3BvcnQuYyB8ICAyICstCiA2IGZpbGVzIGNoYW5nZWQsIDE0NSBpbnNlcnRp
b25zKCspLCAxMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NpZnNn
bG9iLmggYi9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKaW5kZXggODFlN2E0NWY0MTNkLi42MmQ1
YTU0OTViYjggMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaAorKysgYi9mcy9z
bWIvY2xpZW50L2NpZnNnbG9iLmgKQEAgLTY1MCw2ICs2NTAsNyBAQCBzdHJ1Y3QgVENQX1NlcnZl
cl9JbmZvIHsKIAlib29sIG5vYXV0b3R1bmU7CQkvKiBkbyBub3QgYXV0b3R1bmUgc2VuZCBidWYg
c2l6ZXMgKi8KIAlib29sIG5vc2hhcmVzb2NrOwogCWJvb2wgdGNwX25vZGVsYXk7CisJYm9vbCB0
ZXJtaW5hdGU7CiAJdW5zaWduZWQgaW50IGNyZWRpdHM7ICAvKiBzZW5kIG5vIG1vcmUgcmVxdWVz
dHMgYXQgb25jZSAqLwogCXVuc2lnbmVkIGludCBtYXhfY3JlZGl0czsgLyogY2FuIG92ZXJyaWRl
IGxhcmdlIDMyMDAwIGRlZmF1bHQgYXQgbW50ICovCiAJdW5zaWduZWQgaW50IGluX2ZsaWdodDsg
IC8qIG51bWJlciBvZiByZXF1ZXN0cyBvbiB0aGUgd2lyZSB0byBzZXJ2ZXIgKi8KZGlmZiAtLWdp
dCBhL2ZzL3NtYi9jbGllbnQvY2lmc3Byb3RvLmggYi9mcy9zbWIvY2xpZW50L2NpZnNwcm90by5o
CmluZGV4IDAwYWQ0MTYzM2UyNi4uZDg3ZTJjMjZjY2UyIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xp
ZW50L2NpZnNwcm90by5oCisrKyBiL2ZzL3NtYi9jbGllbnQvY2lmc3Byb3RvLmgKQEAgLTY0MSw2
ICs2NDEsOCBAQCBjaWZzX2NoYW5fbmVlZHNfcmVjb25uZWN0KHN0cnVjdCBjaWZzX3NlcyAqc2Vz
LAogYm9vbAogY2lmc19jaGFuX2lzX2lmYWNlX2FjdGl2ZShzdHJ1Y3QgY2lmc19zZXMgKnNlcywK
IAkJCSAgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKTsKK3ZvaWQKK2NpZnNfZGlzYWJs
ZV9zZWNvbmRhcnlfY2hhbm5lbHMoc3RydWN0IGNpZnNfc2VzICpzZXMpOwogaW50CiBjaWZzX2No
YW5fdXBkYXRlX2lmYWNlKHN0cnVjdCBjaWZzX3NlcyAqc2VzLCBzdHJ1Y3QgVENQX1NlcnZlcl9J
bmZvICpzZXJ2ZXIpOwogaW50CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYyBi
L2ZzL3NtYi9jbGllbnQvY29ubmVjdC5jCmluZGV4IDE0OTA1NDdlYzQ5My4uNTdjMmE3ZGYzNDU3
IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYworKysgYi9mcy9zbWIvY2xpZW50
L2Nvbm5lY3QuYwpAQCAtMjE5LDYgKzIxOSwxNCBAQCBjaWZzX21hcmtfdGNwX3Nlc19jb25uc19m
b3JfcmVjb25uZWN0KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwKIAogCXNwaW5fbG9j
aygmY2lmc190Y3Bfc2VzX2xvY2spOwogCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShzZXMsIG5z
ZXMsICZwc2VydmVyLT5zbWJfc2VzX2xpc3QsIHNtYl9zZXNfbGlzdCkgeworCQkvKgorCQkgKiBp
ZiBjaGFubmVsIGhhcyBiZWVuIG1hcmtlZCBmb3IgdGVybWluYXRpb24sIG5vdGhpbmcgdG8gZG8K
KwkJICogZm9yIHRoZSBjaGFubmVsLiBpbiBmYWN0LCB3ZSBjYW5ub3QgZmluZCB0aGUgY2hhbm5l
bCBmb3IgdGhlCisJCSAqIHNlcnZlci4gU28gc2FmZSB0byBleGl0IGhlcmUKKwkJICovCisJCWlm
IChzZXJ2ZXItPnRlcm1pbmF0ZSkKKwkJCWJyZWFrOworCiAJCS8qIGNoZWNrIGlmIGlmYWNlIGlz
IHN0aWxsIGFjdGl2ZSAqLwogCQlpZiAoIWNpZnNfY2hhbl9pc19pZmFjZV9hY3RpdmUoc2VzLCBz
ZXJ2ZXIpKQogCQkJY2lmc19jaGFuX3VwZGF0ZV9pZmFjZShzZXMsIHNlcnZlcik7CkBAIC0yNTMs
NiArMjYxLDggQEAgY2lmc19tYXJrX3RjcF9zZXNfY29ubnNfZm9yX3JlY29ubmVjdChzdHJ1Y3Qg
VENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiAJCQlzcGluX2xvY2soJnRjb24tPnRjX2xvY2spOwog
CQkJdGNvbi0+c3RhdHVzID0gVElEX05FRURfUkVDT047CiAJCQlzcGluX3VubG9jaygmdGNvbi0+
dGNfbG9jayk7CisKKwkJCWNhbmNlbF9kZWxheWVkX3dvcmsoJnRjb24tPnF1ZXJ5X2ludGVyZmFj
ZXMpOwogCQl9CiAJCWlmIChzZXMtPnRjb25faXBjKSB7CiAJCQlzZXMtPnRjb25faXBjLT5uZWVk
X3JlY29ubmVjdCA9IHRydWU7CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3Nlc3MuYyBiL2Zz
L3NtYi9jbGllbnQvc2Vzcy5jCmluZGV4IDE0NTdmODFhZjBjZi4uMjY3ODRlMzM4Mzg4IDEwMDY0
NAotLS0gYS9mcy9zbWIvY2xpZW50L3Nlc3MuYworKysgYi9mcy9zbWIvY2xpZW50L3Nlc3MuYwpA
QCAtMjg5LDYgKzI4OSw2MCBAQCBpbnQgY2lmc190cnlfYWRkaW5nX2NoYW5uZWxzKHN0cnVjdCBj
aWZzX3NlcyAqc2VzKQogCXJldHVybiBuZXdfY2hhbl9jb3VudCAtIG9sZF9jaGFuX2NvdW50Owog
fQogCisvKgorICogY2FsbGVkIHdoZW4gbXVsdGljaGFubmVsIGlzIGRpc2FibGVkIGJ5IHRoZSBz
ZXJ2ZXIuCisgKiB0aGlzIGFsd2F5cyBnZXRzIGNhbGxlZCBmcm9tIHNtYjJfcmVjb25uZWN0Cisg
KiBhbmQgY2Fubm90IGdldCBjYWxsZWQgaW4gcGFyYWxsZWwgdGhyZWFkcy4KKyAqLwordm9pZAor
Y2lmc19kaXNhYmxlX3NlY29uZGFyeV9jaGFubmVscyhzdHJ1Y3QgY2lmc19zZXMgKnNlcykKK3sK
KwlpbnQgaSwgY2hhbl9jb3VudDsKKwlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXI7CisJ
c3RydWN0IGNpZnNfc2VydmVyX2lmYWNlICppZmFjZTsKKworCXNwaW5fbG9jaygmc2VzLT5jaGFu
X2xvY2spOworCWNoYW5fY291bnQgPSBzZXMtPmNoYW5fY291bnQ7CisJaWYgKGNoYW5fY291bnQg
PT0gMSkKKwkJZ290byBkb25lOworCisJc2VzLT5jaGFuX2NvdW50ID0gMTsKKworCS8qIGZvciBh
bGwgc2Vjb25kYXJ5IGNoYW5uZWxzIHJlc2V0IHRoZSBuZWVkIHJlY29ubmVjdCBiaXQgKi8KKwlz
ZXMtPmNoYW5zX25lZWRfcmVjb25uZWN0ICY9IDE7CisKKwlmb3IgKGkgPSAxOyBpIDwgY2hhbl9j
b3VudDsgaSsrKSB7CisJCWlmYWNlID0gc2VzLT5jaGFuc1tpXS5pZmFjZTsKKwkJc2VydmVyID0g
c2VzLT5jaGFuc1tpXS5zZXJ2ZXI7CisKKwkJaWYgKGlmYWNlKSB7CisJCQlzcGluX2xvY2soJnNl
cy0+aWZhY2VfbG9jayk7CisJCQlrcmVmX3B1dCgmaWZhY2UtPnJlZmNvdW50LCByZWxlYXNlX2lm
YWNlKTsKKwkJCXNlcy0+Y2hhbnNbaV0uaWZhY2UgPSBOVUxMOworCQkJaWZhY2UtPm51bV9jaGFu
bmVscy0tOworCQkJaWYgKGlmYWNlLT53ZWlnaHRfZnVsZmlsbGVkKQorCQkJCWlmYWNlLT53ZWln
aHRfZnVsZmlsbGVkLS07CisJCQlzcGluX3VubG9jaygmc2VzLT5pZmFjZV9sb2NrKTsKKwkJfQor
CisJCXNwaW5fdW5sb2NrKCZzZXMtPmNoYW5fbG9jayk7CisJCWlmIChzZXJ2ZXIgJiYgIXNlcnZl
ci0+dGVybWluYXRlKSB7CisJCQlzZXJ2ZXItPnRlcm1pbmF0ZSA9IHRydWU7CisJCQljaWZzX3Np
Z25hbF9jaWZzZF9mb3JfcmVjb25uZWN0KHNlcnZlciwgZmFsc2UpOworCQl9CisJCXNwaW5fbG9j
aygmc2VzLT5jaGFuX2xvY2spOworCisJCWlmIChzZXJ2ZXIpIHsKKwkJCXNlcy0+Y2hhbnNbaV0u
c2VydmVyID0gTlVMTDsKKwkJCWNpZnNfcHV0X3RjcF9zZXNzaW9uKHNlcnZlciwgZmFsc2UpOwor
CQl9CisKKwl9CisKK2RvbmU6CisJc3Bpbl91bmxvY2soJnNlcy0+Y2hhbl9sb2NrKTsKK30KKwog
LyoKICAqIHVwZGF0ZSB0aGUgaWZhY2UgZm9yIHRoZSBjaGFubmVsIGlmIG5lY2Vzc2FyeS4KICAq
IHdpbGwgcmV0dXJuIDAgd2hlbiBpZmFjZSBpcyB1cGRhdGVkLCAxIGlmIHJlbW92ZWQsIDIgb3Ro
ZXJ3aXNlCkBAIC01ODYsMTQgKzY0MCwxMCBAQCBjaWZzX3Nlc19hZGRfY2hhbm5lbChzdHJ1Y3Qg
Y2lmc19zZXMgKnNlcywKIAogb3V0OgogCWlmIChyYyAmJiBjaGFuLT5zZXJ2ZXIpIHsKLQkJLyoK
LQkJICogd2Ugc2hvdWxkIGF2b2lkIHJhY2Ugd2l0aCB0aGVzZSBkZWxheWVkIHdvcmtzIGJlZm9y
ZSB3ZQotCQkgKiByZW1vdmUgdGhpcyBjaGFubmVsCi0JCSAqLwotCQljYW5jZWxfZGVsYXllZF93
b3JrX3N5bmMoJmNoYW4tPnNlcnZlci0+ZWNobyk7Ci0JCWNhbmNlbF9kZWxheWVkX3dvcmtfc3lu
YygmY2hhbi0+c2VydmVyLT5yZWNvbm5lY3QpOworCQljaWZzX3B1dF90Y3Bfc2Vzc2lvbihjaGFu
LT5zZXJ2ZXIsIDApOwogCiAJCXNwaW5fbG9jaygmc2VzLT5jaGFuX2xvY2spOworCiAJCS8qIHdl
IHJlbHkgb24gYWxsIGJpdHMgYmV5b25kIGNoYW5fY291bnQgdG8gYmUgY2xlYXIgKi8KIAkJY2lm
c19jaGFuX2NsZWFyX25lZWRfcmVjb25uZWN0KHNlcywgY2hhbi0+c2VydmVyKTsKIAkJc2VzLT5j
aGFuX2NvdW50LS07CkBAIC02MDMsOCArNjUzLDYgQEAgY2lmc19zZXNfYWRkX2NoYW5uZWwoc3Ry
dWN0IGNpZnNfc2VzICpzZXMsCiAJCSAqLwogCQlXQVJOX09OKHNlcy0+Y2hhbl9jb3VudCA8IDEp
OwogCQlzcGluX3VubG9jaygmc2VzLT5jaGFuX2xvY2spOwotCi0JCWNpZnNfcHV0X3RjcF9zZXNz
aW9uKGNoYW4tPnNlcnZlciwgMCk7CiAJfQogCiAJa2ZyZWUoY3R4LT5VTkMpOwpkaWZmIC0tZ2l0
IGEvZnMvc21iL2NsaWVudC9zbWIycGR1LmMgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwppbmRl
eCAwZDQzNTFlNDMwNjkuLjJlYjI5ZmEyNzhjMyAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9z
bWIycGR1LmMKKysrIGIvZnMvc21iL2NsaWVudC9zbWIycGR1LmMKQEAgLTE2NCw2ICsxNjQsOCBA
QCBzbWIyX3JlY29ubmVjdChfX2xlMTYgc21iMl9jb21tYW5kLCBzdHJ1Y3QgY2lmc190Y29uICp0
Y29uLAogCXN0cnVjdCBubHNfdGFibGUgKm5sc19jb2RlcGFnZSA9IE5VTEw7CiAJc3RydWN0IGNp
ZnNfc2VzICpzZXM7CiAJaW50IHhpZDsKKwlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpwc2VydmVy
OworCXVuc2lnbmVkIGludCBjaGFuX2luZGV4OwogCiAJLyoKIAkgKiBTTUIycyBOZWdQcm90LCBT
ZXNzU2V0dXAsIExvZ29mZiBkbyBub3QgaGF2ZSB0Y29uIHlldCBzbwpAQCAtMjI0LDYgKzIyNiwx
MiBAQCBzbWIyX3JlY29ubmVjdChfX2xlMTYgc21iMl9jb21tYW5kLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAogCQkJcmV0dXJuIC1FQUdBSU47CiAJCX0KIAl9CisKKwkvKiBpZiBzZXJ2ZXIgaXMg
bWFya2VkIGZvciB0ZXJtaW5hdGlvbiwgY2lmc2Qgd2lsbCBjbGVhbnVwICovCisJaWYgKHNlcnZl
ci0+dGVybWluYXRlKSB7CisJCXNwaW5fdW5sb2NrKCZzZXJ2ZXItPnNydl9sb2NrKTsKKwkJcmV0
dXJuIC1FSE9TVERPV047CisJfQogCXNwaW5fdW5sb2NrKCZzZXJ2ZXItPnNydl9sb2NrKTsKIAog
YWdhaW46CkBAIC0yNDIsMTIgKzI1MCwyNCBAQCBzbWIyX3JlY29ubmVjdChfX2xlMTYgc21iMl9j
b21tYW5kLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkgdGNvbi0+bmVlZF9yZWNvbm5lY3Qp
OwogCiAJbXV0ZXhfbG9jaygmc2VzLT5zZXNzaW9uX211dGV4KTsKKwkvKgorCSAqIGlmIHRoaXMg
aXMgY2FsbGVkIGJ5IGRlbGF5ZWQgd29yaywgYW5kIHRoZSBjaGFubmVsIGhhcyBiZWVuIGRpc2Fi
bGVkCisJICogaW4gcGFyYWxsZWwsIHRoZSBkZWxheWVkIHdvcmsgY2FuIGNvbnRpbnVlIHRvIGV4
ZWN1dGUgaW4gcGFyYWxsZWwKKwkgKiB0aGVyZSdzIGEgY2hhbmNlIHRoYXQgdGhpcyBjaGFubmVs
IG1heSBub3QgZXhpc3QgYW55bW9yZQorCSAqLworCXNwaW5fbG9jaygmc2VydmVyLT5zcnZfbG9j
ayk7CisJaWYgKHNlcnZlci0+dGNwU3RhdHVzID09IENpZnNFeGl0aW5nKSB7CisJCXNwaW5fdW5s
b2NrKCZzZXJ2ZXItPnNydl9sb2NrKTsKKwkJbXV0ZXhfdW5sb2NrKCZzZXMtPnNlc3Npb25fbXV0
ZXgpOworCQlyYyA9IC1FSE9TVERPV047CisJCWdvdG8gb3V0OworCX0KKwogCS8qCiAJICogUmVj
aGVjayBhZnRlciBhY3F1aXJlIG11dGV4LiBJZiBhbm90aGVyIHRocmVhZCBpcyBuZWdvdGlhdGlu
ZwogCSAqIGFuZCB0aGUgc2VydmVyIG5ldmVyIHNlbmRzIGFuIGFuc3dlciB0aGUgc29ja2V0IHdp
bGwgYmUgY2xvc2VkCiAJICogYW5kIHRjcFN0YXR1cyBzZXQgdG8gcmVjb25uZWN0LgogCSAqLwot
CXNwaW5fbG9jaygmc2VydmVyLT5zcnZfbG9jayk7CiAJaWYgKHNlcnZlci0+dGNwU3RhdHVzID09
IENpZnNOZWVkUmVjb25uZWN0KSB7CiAJCXNwaW5fdW5sb2NrKCZzZXJ2ZXItPnNydl9sb2NrKTsK
IAkJbXV0ZXhfdW5sb2NrKCZzZXMtPnNlc3Npb25fbXV0ZXgpOwpAQCAtMjg0LDYgKzMwNCw1MyBA
QCBzbWIyX3JlY29ubmVjdChfX2xlMTYgc21iMl9jb21tYW5kLCBzdHJ1Y3QgY2lmc190Y29uICp0
Y29uLAogCiAJcmMgPSBjaWZzX25lZ290aWF0ZV9wcm90b2NvbCgwLCBzZXMsIHNlcnZlcik7CiAJ
aWYgKCFyYykgeworCQkvKgorCQkgKiBpZiBzZXJ2ZXIgc3RvcHBlZCBzdXBwb3J0aW5nIG11bHRp
Y2hhbm5lbAorCQkgKiBhbmQgdGhlIGZpcnN0IGNoYW5uZWwgcmVjb25uZWN0ZWQsIGRpc2FibGUg
YWxsIHRoZSBvdGhlcnMuCisJCSAqLworCQlpZiAoc2VzLT5jaGFuX2NvdW50ID4gMSAmJgorCQkg
ICAgIShzZXJ2ZXItPmNhcGFiaWxpdGllcyAmIFNNQjJfR0xPQkFMX0NBUF9NVUxUSV9DSEFOTkVM
KSkgeworCQkJaWYgKFNFUlZFUl9JU19DSEFOKHNlcnZlcikpIHsKKwkJCQljaWZzX2RiZyhWRlMs
ICJzZXJ2ZXIgJXMgZG9lcyBub3Qgc3VwcG9ydCAiIFwKKwkJCQkJICJtdWx0aWNoYW5uZWwgYW55
bW9yZS4gc2tpcHBpbmcgc2Vjb25kYXJ5IGNoYW5uZWxcbiIsCisJCQkJCSBzZXMtPnNlcnZlci0+
aG9zdG5hbWUpOworCisJCQkJc3Bpbl9sb2NrKCZzZXMtPmNoYW5fbG9jayk7CisJCQkJY2hhbl9p
bmRleCA9IGNpZnNfc2VzX2dldF9jaGFuX2luZGV4KHNlcywgc2VydmVyKTsKKwkJCQlpZiAoY2hh
bl9pbmRleCA9PSBDSUZTX0lOVkFMX0NIQU5fSU5ERVgpIHsKKwkJCQkJc3Bpbl91bmxvY2soJnNl
cy0+Y2hhbl9sb2NrKTsKKwkJCQkJZ290byBza2lwX3Rlcm1pbmF0ZTsKKwkJCQl9CisKKwkJCQlz
ZXMtPmNoYW5zW2NoYW5faW5kZXhdLnNlcnZlciA9IE5VTEw7CisJCQkJc3Bpbl91bmxvY2soJnNl
cy0+Y2hhbl9sb2NrKTsKKworCQkJCS8qCisJCQkJICogdGhlIGFib3ZlIHJlZmVyZW5jZSBvZiBz
ZXJ2ZXIgYnkgY2hhbm5lbAorCQkJCSAqIG5lZWRzIHRvIGJlIGRyb3BwZWQgd2l0aG91dCBob2xk
aW5nIGNoYW5fbG9jaworCQkJCSAqIGFzIGNpZnNfcHV0X3RjcF9zZXNzaW9uIHRha2VzIGEgaGln
aGVyIGxvY2sKKwkJCQkgKiBpLmUuIGNpZnNfdGNwX3Nlc19sb2NrCisJCQkJICovCisJCQkJY2lm
c19wdXRfdGNwX3Nlc3Npb24oc2VydmVyLCAxKTsKKworCQkJCXNlcnZlci0+dGVybWluYXRlID0g
dHJ1ZTsKKwkJCQljaWZzX3NpZ25hbF9jaWZzZF9mb3JfcmVjb25uZWN0KHNlcnZlciwgZmFsc2Up
OworCisJCQkJLyogbWFyayBwcmltYXJ5IHNlcnZlciBhcyBuZWVkaW5nIHJlY29ubmVjdCAqLwor
CQkJCXBzZXJ2ZXIgPSBzZXJ2ZXItPnByaW1hcnlfc2VydmVyOworCQkJCWNpZnNfc2lnbmFsX2Np
ZnNkX2Zvcl9yZWNvbm5lY3QocHNlcnZlciwgZmFsc2UpOworCitza2lwX3Rlcm1pbmF0ZToKKwkJ
CQltdXRleF91bmxvY2soJnNlcy0+c2Vzc2lvbl9tdXRleCk7CisJCQkJcmMgPSAtRUhPU1RET1dO
OworCQkJCWdvdG8gb3V0OworCQkJfSBlbHNlIHsKKwkJCQljaWZzX3NlcnZlcl9kYmcoVkZTLCAi
ZG9lcyBub3Qgc3VwcG9ydCAiIFwKKwkJCQkJICJtdWx0aWNoYW5uZWwgYW55bW9yZS4gZGlzYWJs
aW5nIGFsbCBvdGhlciBjaGFubmVsc1xuIik7CisJCQkJY2lmc19kaXNhYmxlX3NlY29uZGFyeV9j
aGFubmVscyhzZXMpOworCQkJfQorCQl9CisKIAkJcmMgPSBjaWZzX3NldHVwX3Nlc3Npb24oMCwg
c2VzLCBzZXJ2ZXIsIG5sc19jb2RlcGFnZSk7CiAJCWlmICgocmMgPT0gLUVBQ0NFUykgJiYgIXRj
b24tPnJldHJ5KSB7CiAJCQltdXRleF91bmxvY2soJnNlcy0+c2Vzc2lvbl9tdXRleCk7CkBAIC0z
ODM2LDYgKzM5MDMsMTMgQEAgdm9pZCBzbWIyX3JlY29ubmVjdF9zZXJ2ZXIoc3RydWN0IHdvcmtf
c3RydWN0ICp3b3JrKQogCS8qIFByZXZlbnQgc2ltdWx0YW5lb3VzIHJlY29ubmVjdHMgdGhhdCBj
YW4gY29ycnVwdCB0Y29uLT5ybGlzdCBsaXN0ICovCiAJbXV0ZXhfbG9jaygmcHNlcnZlci0+cmVj
b25uZWN0X211dGV4KTsKIAorCS8qIGlmIHRoZSBzZXJ2ZXIgaXMgbWFya2VkIGZvciB0ZXJtaW5h
dGlvbiwgZHJvcCB0aGUgcmVmIGNvdW50IGhlcmUgKi8KKwlpZiAoc2VydmVyLT50ZXJtaW5hdGUp
IHsKKwkJY2lmc19wdXRfdGNwX3Nlc3Npb24oc2VydmVyLCB0cnVlKTsKKwkJbXV0ZXhfdW5sb2Nr
KCZwc2VydmVyLT5yZWNvbm5lY3RfbXV0ZXgpOworCQlyZXR1cm47CisJfQorCiAJSU5JVF9MSVNU
X0hFQUQoJnRtcF9saXN0KTsKIAlJTklUX0xJU1RfSEVBRCgmdG1wX3Nlc19saXN0KTsKIAljaWZz
X2RiZyhGWUksICJSZWNvbm5lY3RpbmcgdGNvbnMgYW5kIGNoYW5uZWxzXG4iKTsKZGlmZiAtLWdp
dCBhL2ZzL3NtYi9jbGllbnQvdHJhbnNwb3J0LmMgYi9mcy9zbWIvY2xpZW50L3RyYW5zcG9ydC5j
CmluZGV4IGQ1NTNiN2E1NDYyMS4uNGY3MTdhZDdjMjFiIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xp
ZW50L3RyYW5zcG9ydC5jCisrKyBiL2ZzL3NtYi9jbGllbnQvdHJhbnNwb3J0LmMKQEAgLTEwMjMs
NyArMTAyMyw3IEBAIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKmNpZnNfcGlja19jaGFubmVsKHN0
cnVjdCBjaWZzX3NlcyAqc2VzKQogCXNwaW5fbG9jaygmc2VzLT5jaGFuX2xvY2spOwogCWZvciAo
aSA9IDA7IGkgPCBzZXMtPmNoYW5fY291bnQ7IGkrKykgewogCQlzZXJ2ZXIgPSBzZXMtPmNoYW5z
W2ldLnNlcnZlcjsKLQkJaWYgKCFzZXJ2ZXIpCisJCWlmICghc2VydmVyIHx8IHNlcnZlci0+dGVy
bWluYXRlKQogCQkJY29udGludWU7CiAKIAkJLyoKLS0gCjIuMzQuMQoK
--000000000000301cb50609c47c75
Content-Type: application/octet-stream; 
	name="0006-cifs-handle-when-server-starts-supporting-multichann.patch"
Content-Disposition: attachment; 
	filename="0006-cifs-handle-when-server-starts-supporting-multichann.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_los3lgea1>
X-Attachment-Id: f_los3lgea1

RnJvbSBiNmY0MTBjYjg2MzVkMDE4NzU5MzhmMzk5MWQ3YjA5M2Q4M2UyNjRkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDEzIE9jdCAyMDIzIDExOjMzOjIxICswMDAwClN1YmplY3Q6IFtQQVRDSCA2
LzldIGNpZnM6IGhhbmRsZSB3aGVuIHNlcnZlciBzdGFydHMgc3VwcG9ydGluZyBtdWx0aWNoYW5u
ZWwKCldoZW4gdGhlIHVzZXIgbW91bnRzIHdpdGggbXVsdGljaGFubmVsIG9wdGlvbiwgYnV0IHRo
ZQpzZXJ2ZXIgZG9lcyBub3Qgc3VwcG9ydCBpdCwgdGhlcmUgY2FuIGJlIGEgdGltZSBpbiBmdXR1
cmUKd2hlcmUgaXQgY2FuIGJlIHN1cHBvcnRlZC4KCldpdGggdGhpcyBjaGFuZ2UsIHN1Y2ggYSBj
YXNlIGlzIGhhbmRsZWQuCgpTaWduZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBt
aWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvY2lmc3Byb3RvLmggfCAgMSArCiBmcy9z
bWIvY2xpZW50L2Nvbm5lY3QuYyAgIHwgIDMgKysrCiBmcy9zbWIvY2xpZW50L3NtYjJwZHUuYyAg
IHwgMzIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0KIDMgZmlsZXMgY2hhbmdlZCwg
MzQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xp
ZW50L2NpZnNwcm90by5oIGIvZnMvc21iL2NsaWVudC9jaWZzcHJvdG8uaAppbmRleCBlZWQ4ZGJi
NmIyZmIuLjAwYWQ0MTYzM2UyNiAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzcHJvdG8u
aAorKysgYi9mcy9zbWIvY2xpZW50L2NpZnNwcm90by5oCkBAIC0xMzIsNiArMTMyLDcgQEAgZXh0
ZXJuIGludCBTZW5kUmVjZWl2ZUJsb2NraW5nTG9jayhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLAog
CQkJc3RydWN0IHNtYl9oZHIgKmluX2J1ZiwKIAkJCXN0cnVjdCBzbWJfaGRyICpvdXRfYnVmLAog
CQkJaW50ICpieXRlc19yZXR1cm5lZCk7CisKIHZvaWQKIGNpZnNfc2lnbmFsX2NpZnNkX2Zvcl9y
ZWNvbm5lY3Qoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLAogCQkJCSAgICAgIGJvb2wg
YWxsX2NoYW5uZWxzKTsKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY29ubmVjdC5jIGIvZnMv
c21iL2NsaWVudC9jb25uZWN0LmMKaW5kZXggYjUxNGI0MWNjOWYwLi4xNDkwNTQ3ZWM0OTMgMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY29ubmVjdC5jCisrKyBiL2ZzL3NtYi9jbGllbnQvY29u
bmVjdC5jCkBAIC0xMzIsNiArMTMyLDkgQEAgc3RhdGljIHZvaWQgc21iMl9xdWVyeV9zZXJ2ZXJf
aW50ZXJmYWNlcyhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJZnJlZV94aWQoeGlkKTsKIAog
CWlmIChyYykgeworCQlpZiAocmMgPT0gLUVPUE5PVFNVUFApCisJCQlyZXR1cm47CisKIAkJY2lm
c19kYmcoRllJLCAiJXM6IGZhaWxlZCB0byBxdWVyeSBzZXJ2ZXIgaW50ZXJmYWNlczogJWRcbiIs
CiAJCQkJX19mdW5jX18sIHJjKTsKIAl9CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3NtYjJw
ZHUuYyBiL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCmluZGV4IGI3NjY1MTU1ZjRlMi4uMGQ0MzUx
ZTQzMDY5IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYworKysgYi9mcy9zbWIv
Y2xpZW50L3NtYjJwZHUuYwpAQCAtMTYzLDYgKzE2Myw3IEBAIHNtYjJfcmVjb25uZWN0KF9fbGUx
NiBzbWIyX2NvbW1hbmQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJaW50IHJjID0gMDsKIAlz
dHJ1Y3QgbmxzX3RhYmxlICpubHNfY29kZXBhZ2UgPSBOVUxMOwogCXN0cnVjdCBjaWZzX3NlcyAq
c2VzOworCWludCB4aWQ7CiAKIAkvKgogCSAqIFNNQjJzIE5lZ1Byb3QsIFNlc3NTZXR1cCwgTG9n
b2ZmIGRvIG5vdCBoYXZlIHRjb24geWV0IHNvCkBAIC0zMDcsMTcgKzMwOCw0NCBAQCBzbWIyX3Jl
Y29ubmVjdChfX2xlMTYgc21iMl9jb21tYW5kLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQl0
Y29uLT5uZWVkX3Jlb3Blbl9maWxlcyA9IHRydWU7CiAKIAlyYyA9IGNpZnNfdHJlZV9jb25uZWN0
KDAsIHRjb24sIG5sc19jb2RlcGFnZSk7Ci0JbXV0ZXhfdW5sb2NrKCZzZXMtPnNlc3Npb25fbXV0
ZXgpOwogCiAJY2lmc19kYmcoRllJLCAicmVjb25uZWN0IHRjb24gcmMgPSAlZFxuIiwgcmMpOwog
CWlmIChyYykgewogCQkvKiBJZiBzZXNzIHJlY29ubmVjdGVkIGJ1dCB0Y29uIGRpZG4ndCwgc29t
ZXRoaW5nIHN0cmFuZ2UgLi4uICovCisJCW11dGV4X3VubG9jaygmc2VzLT5zZXNzaW9uX211dGV4
KTsKIAkJY2lmc19kYmcoVkZTLCAicmVjb25uZWN0IHRjb24gZmFpbGVkIHJjID0gJWRcbiIsIHJj
KTsKIAkJZ290byBvdXQ7CiAJfQogCisJaWYgKCFyYyAmJgorCSAgICAoc2VydmVyLT5jYXBhYmls
aXRpZXMgJiBTTUIyX0dMT0JBTF9DQVBfTVVMVElfQ0hBTk5FTCkpIHsKKwkJbXV0ZXhfdW5sb2Nr
KCZzZXMtPnNlc3Npb25fbXV0ZXgpOworCisJCS8qCisJCSAqIHF1ZXJ5IHNlcnZlciBuZXR3b3Jr
IGludGVyZmFjZXMsIGluIGNhc2UgdGhleSBjaGFuZ2UKKwkJICovCisJCXhpZCA9IGdldF94aWQo
KTsKKwkJcmMgPSBTTUIzX3JlcXVlc3RfaW50ZXJmYWNlcyh4aWQsIHRjb24sIGZhbHNlKTsKKwkJ
ZnJlZV94aWQoeGlkKTsKKworCQlpZiAocmMpCisJCQljaWZzX2RiZyhGWUksICIlczogZmFpbGVk
IHRvIHF1ZXJ5IHNlcnZlciBpbnRlcmZhY2VzOiAlZFxuIiwKKwkJCQkgX19mdW5jX18sIHJjKTsK
KworCQlpZiAoc2VzLT5jaGFuX21heCA+IHNlcy0+Y2hhbl9jb3VudCAmJgorCQkgICAgIVNFUlZF
Ul9JU19DSEFOKHNlcnZlcikpIHsKKwkJCWlmIChzZXMtPmNoYW5fY291bnQgPT0gMSkKKwkJCQlj
aWZzX3NlcnZlcl9kYmcoVkZTLCAic3VwcG9ydHMgbXVsdGljaGFubmVsIG5vd1xuIik7CisKKwkJ
CWNpZnNfdHJ5X2FkZGluZ19jaGFubmVscyhzZXMpOworCQl9CisJfSBlbHNlIHsKKwkJbXV0ZXhf
dW5sb2NrKCZzZXMtPnNlc3Npb25fbXV0ZXgpOworCX0KKwogCWlmIChzbWIyX2NvbW1hbmQgIT0g
U01CMl9JTlRFUk5BTF9DTUQpCi0JCW1vZF9kZWxheWVkX3dvcmsoY2lmc2lvZF93cSwgJnNlcnZl
ci0+cmVjb25uZWN0LCAwKTsKKwkJaWYgKG1vZF9kZWxheWVkX3dvcmsoY2lmc2lvZF93cSwgJnNl
cnZlci0+cmVjb25uZWN0LCAwKSkKKwkJCWNpZnNfcHV0X3RjcF9zZXNzaW9uKHNlcnZlciwgZmFs
c2UpOwogCiAJYXRvbWljX2luYygmdGNvbkluZm9SZWNvbm5lY3RDb3VudCk7CiBvdXQ6Ci0tIAoy
LjM0LjEKCg==
--000000000000301cb50609c47c75--
