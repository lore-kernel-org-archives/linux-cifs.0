Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0AC10A32
	for <linux-cifs@vger.kernel.org>; Sat, 10 Feb 2024 06:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707546151; cv=none; b=Hy1fnz4CeCOBW8tTO7W2DGnpKXsQCpQwkqAFWK684TkqT/Tzn8XGjPMqs2kuen3xzamAi0Z/RTqJe7BtLkmLix2xdlyAgmuhPbNnHHS4UHpU/FmWyqqj1vunUsoM0RLT5SNAlP73sSwolOYYT/0EjgYUCSzmhQqdAgtpo8wFfnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707546151; c=relaxed/simple;
	bh=RmF/PcfdYtdcczokVNF3okQnccDE+YQyIiIWyQ61MSA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cYRRQsy7MztqkajzjrRMyaVh7kYau8NLx8xmcZ3JPPxaYEBxNW752XcX0kWMIe11JPGaHFeqo051Sleb/aFlSS9pVt5jsilvlZ43ZYaHUYItErDTKNPpl4oEVnvSVTp5uyxM/Kk+oiOO/2FV/oxjTEY5OQgubQxI2wkEY4Xswvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c8V4AmBf; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c8V4AmBf"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d09faadba5so20935881fa.1
        for <linux-cifs@vger.kernel.org>; Fri, 09 Feb 2024 22:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707546147; x=1708150947; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IH8umxOtblfjez2okkqYIOiAN5xvDSjf2fJjS7gunSc=;
        b=c8V4AmBf/GVZPgIY4WpofhRDaBO0qVHQC0jHBhjUYoPrxppnbvdcds/zNIRGBsSq+E
         tY1KKFegpmJ7MXY/IFJvLZtZLsTTxPBOoKUHkR9SmcTaeJWvNSCV4qAGZM+S7Uq3s9XY
         gv6k5ybQPPMcUVk146YRWlmd9VdZAjEfX2ZDBboTaIRQ0j68OBA3zidsSd6CtYHyY9lm
         BNTEmrchEgn+zbacBxq047IC4PPyXBONDtlkVv+PJ1BoXLXklNcps37CGs+w/cj4L4g4
         efpqNVcGN8EbLFZXSAWm7oR1gyovzMgB88LVAcHvQlaKZCqVBox692UDmBFoyyF4eROb
         hqGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707546147; x=1708150947;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IH8umxOtblfjez2okkqYIOiAN5xvDSjf2fJjS7gunSc=;
        b=o+JomrnC6/sKBsHUqSk2+9no0FdAz4es+BVjsgcYw09Qye6STW5R2s9O0NM9uxku7j
         +vaQ7MV4cTcg12HEoTWaQbWxO9kq6sRJHrjD0WK2s5blK59aKUtbo0gxgK8NrxVayMwt
         OxY3J0rAv/Y9RhjjNgeHsLbEuTXfuhFJLfAqn6a1EX3H1N+3hYHPj1xomx1PZLbGuJoY
         i6tn0hkaSauZGEmM5FxZ66ZYnYkVIx6JqsFWbiWZyWBrjgE/9UXEFhhV4oG5LZXVN6Dp
         1QI2wJ8NTFLgmGYZrxOMrFmx2Brxyv1PB1lh3/ieQ8LwKp+feIQmHvk9uq5g2lrNOks6
         jxyg==
X-Gm-Message-State: AOJu0YwIJNIohBG+ZbLDh0a9VYMN5Trg4j9i8TRPJzxRVC5/vYK8qdzq
	vk/J5KIQsMvM+d5+rYXX/mXVEL47PkbztG/d/IzA/Gw8GjYc+1YlX0+gCbYpP+Gk3xhwg5lj7Z9
	+TyjLkQGhvrLc/GD1p92D/OWaZ6clY+gLYWJ+Ww==
X-Google-Smtp-Source: AGHT+IHdHIloj3yI0NSRni3qReACgmx8s6m2XIQUrNg0Lhpsa4UsuIZlGiLxwl5z9Jc5wuFKeyAnbhukroQrYDsruaA=
X-Received: by 2002:a2e:7302:0:b0:2d0:b291:d017 with SMTP id
 o2-20020a2e7302000000b002d0b291d017mr663982ljc.15.1707546146817; Fri, 09 Feb
 2024 22:22:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240209112542.55690-1-sprasad@microsoft.com>
In-Reply-To: <20240209112542.55690-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 10 Feb 2024 00:22:15 -0600
Message-ID: <CAH2r5muugdPoB1O0+PdPZcm2WFbL=VWS+t6OqNCpeUy2gyVVeA@mail.gmail.com>
Subject: Re: [PATCH] cifs: update the same create_guid on replay
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	tom@talpey.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="00000000000084dffd06110111c4"

--00000000000084dffd06110111c4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It needed a small rebase to work around one of Paulo's patches which
it depended on (which is for 6.9-rc) but was wondering if you want
this patch in before 6.9 because its change to smb2_compound_op below
has a dependency on another patch - can that change be safely removed?

replay_again:
        /* reinitialize for possible replay */
        flags =3D 0;
        oplock =3D SMB2_OPLOCK_LEVEL_NONE;
        num_rqst =3D 0;
        server =3D cifs_pick_channel(ses);
        oparms->replay =3D !!(retries);

On Fri, Feb 9, 2024 at 5:25=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> File open requests made to the server contain a
> CreateGuid, which is used by the server to identify
> the open request. If the same request needs to be
> replayed, it needs to be sent with the same CreateGuid
> in the durable handle v2 context.
>
> Without doing so, we could end up leaking handles on
> the server when:
> 1. multichannel is used AND
> 2. connection goes down, but not for all channels
>
> This is because the replayed open request would have a
> new CreateGuid and the server will treat this as a new
> request and open a new handle.
>
> This change fixes this by reusing the existing create_guid
> stored in the cached fid struct.
>
> REF: MS-SMB2 4.9 Replay Create Request on an Alternate Channel
>
> Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay =
flag set")
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cached_dir.c |  1 +
>  fs/smb/client/cifsglob.h   |  1 +
>  fs/smb/client/smb2inode.c  |  1 +
>  fs/smb/client/smb2ops.c    |  4 ++++
>  fs/smb/client/smb2pdu.c    | 10 ++++++++--
>  5 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index 1daeb5714faa..3de5047a7ff9 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -242,6 +242,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tco=
n *tcon,
>                 .desired_access =3D  FILE_READ_DATA | FILE_READ_ATTRIBUTE=
S,
>                 .disposition =3D FILE_OPEN,
>                 .fid =3D pfid,
> +               .replay =3D !!(retries),
>         };
>
>         rc =3D SMB2_open_init(tcon, server,
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index cac10f8e17e4..efab4769de4e 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1373,6 +1373,7 @@ struct cifs_open_parms {
>         struct cifs_fid *fid;
>         umode_t mode;
>         bool reconnect:1;
> +       bool replay:1; /* indicates that this open is for a replay */
>         struct kvec *ea_cctx;
>  };
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 63485078a6df..22bd01e7bf6e 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -203,6 +203,7 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>         oplock =3D SMB2_OPLOCK_LEVEL_NONE;
>         num_rqst =3D 0;
>         server =3D cifs_pick_channel(ses);
> +       oparms->replay =3D !!(retries);
>
>         vars =3D kzalloc(sizeof(*vars), GFP_ATOMIC);
>         if (vars =3D=3D NULL)
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 8d674aef8dd9..c0da1935b0bd 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -1205,6 +1205,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tco=
n *tcon,
>                 .disposition =3D FILE_OPEN,
>                 .create_options =3D cifs_create_options(cifs_sb, 0),
>                 .fid =3D &fid,
> +               .replay =3D !!(retries),
>         };
>
>         rc =3D SMB2_open_init(tcon, server,
> @@ -1570,6 +1571,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>                 .disposition =3D FILE_OPEN,
>                 .create_options =3D cifs_create_options(cifs_sb, create_o=
ptions),
>                 .fid =3D &fid,
> +               .replay =3D !!(retries),
>         };
>
>         if (qi.flags & PASSTHRU_FSCTL) {
> @@ -2296,6 +2298,7 @@ smb2_query_dir_first(const unsigned int xid, struct=
 cifs_tcon *tcon,
>                 .disposition =3D FILE_OPEN,
>                 .create_options =3D cifs_create_options(cifs_sb, 0),
>                 .fid =3D fid,
> +               .replay =3D !!(retries),
>         };
>
>         rc =3D SMB2_open_init(tcon, server,
> @@ -2682,6 +2685,7 @@ smb2_query_info_compound(const unsigned int xid, st=
ruct cifs_tcon *tcon,
>                 .disposition =3D FILE_OPEN,
>                 .create_options =3D cifs_create_options(cifs_sb, 0),
>                 .fid =3D &fid,
> +               .replay =3D !!(retries),
>         };
>
>         rc =3D SMB2_open_init(tcon, server,
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 2ecc5f210329..1ce9be3a7ca7 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -2406,8 +2406,13 @@ create_durable_v2_buf(struct cifs_open_parms *opar=
ms)
>          */
>         buf->dcontext.Timeout =3D cpu_to_le32(oparms->tcon->handle_timeou=
t);
>         buf->dcontext.Flags =3D cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTENT)=
;
> -       generate_random_uuid(buf->dcontext.CreateGuid);
> -       memcpy(pfid->create_guid, buf->dcontext.CreateGuid, 16);
> +
> +       /* for replay, we should not overwrite the existing create guid *=
/
> +       if (!oparms->replay) {
> +               generate_random_uuid(buf->dcontext.CreateGuid);
> +               memcpy(pfid->create_guid, buf->dcontext.CreateGuid, 16);
> +       } else
> +               memcpy(buf->dcontext.CreateGuid, pfid->create_guid, 16);
>
>         /* SMB2_CREATE_DURABLE_HANDLE_REQUEST is "DH2Q" */
>         buf->Name[0] =3D 'D';
> @@ -3156,6 +3161,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_=
parms *oparms, __le16 *path,
>         /* reinitialize for possible replay */
>         flags =3D 0;
>         server =3D cifs_pick_channel(ses);
> +       oparms->replay =3D !!(retries);
>
>         cifs_dbg(FYI, "create/open\n");
>         if (!ses || !server)
> --
> 2.34.1
>


--=20
Thanks,

Steve

--00000000000084dffd06110111c4
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-update-the-same-create_guid-on-replay.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-update-the-same-create_guid-on-replay.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lsfov6690>
X-Attachment-Id: f_lsfov6690

RnJvbSA2NTc3NDkyOWZjYWJlODQ5MmEyYjM4ODY1NzRhYjE0OTVhMTNmN2U2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDkgRmViIDIwMjQgMTE6MjU6NDIgKzAwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiB1cGRhdGUgdGhlIHNhbWUgY3JlYXRlX2d1aWQgb24gcmVwbGF5CgpGaWxlIG9wZW4gcmVx
dWVzdHMgbWFkZSB0byB0aGUgc2VydmVyIGNvbnRhaW4gYQpDcmVhdGVHdWlkLCB3aGljaCBpcyB1
c2VkIGJ5IHRoZSBzZXJ2ZXIgdG8gaWRlbnRpZnkKdGhlIG9wZW4gcmVxdWVzdC4gSWYgdGhlIHNh
bWUgcmVxdWVzdCBuZWVkcyB0byBiZQpyZXBsYXllZCwgaXQgbmVlZHMgdG8gYmUgc2VudCB3aXRo
IHRoZSBzYW1lIENyZWF0ZUd1aWQKaW4gdGhlIGR1cmFibGUgaGFuZGxlIHYyIGNvbnRleHQuCgpX
aXRob3V0IGRvaW5nIHNvLCB3ZSBjb3VsZCBlbmQgdXAgbGVha2luZyBoYW5kbGVzIG9uCnRoZSBz
ZXJ2ZXIgd2hlbjoKMS4gbXVsdGljaGFubmVsIGlzIHVzZWQgQU5ECjIuIGNvbm5lY3Rpb24gZ29l
cyBkb3duLCBidXQgbm90IGZvciBhbGwgY2hhbm5lbHMKClRoaXMgaXMgYmVjYXVzZSB0aGUgcmVw
bGF5ZWQgb3BlbiByZXF1ZXN0IHdvdWxkIGhhdmUgYQpuZXcgQ3JlYXRlR3VpZCBhbmQgdGhlIHNl
cnZlciB3aWxsIHRyZWF0IHRoaXMgYXMgYSBuZXcKcmVxdWVzdCBhbmQgb3BlbiBhIG5ldyBoYW5k
bGUuCgpUaGlzIGNoYW5nZSBmaXhlcyB0aGlzIGJ5IHJldXNpbmcgdGhlIGV4aXN0aW5nIGNyZWF0
ZV9ndWlkCnN0b3JlZCBpbiB0aGUgY2FjaGVkIGZpZCBzdHJ1Y3QuCgpSRUY6IE1TLVNNQjIgNC45
IFJlcGxheSBDcmVhdGUgUmVxdWVzdCBvbiBhbiBBbHRlcm5hdGUgQ2hhbm5lbAoKRml4ZXM6IDRm
MWZmZmEyMzc2OSAoImNpZnM6IGNvbW1hbmRzIHRoYXQgYXJlIHJldHJpZWQgc2hvdWxkIGhhdmUg
cmVwbGF5IGZsYWcgc2V0IikKU2lnbmVkLW9mZi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRA
bWljcm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNy
b3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jIHwgIDEgKwogZnMvc21i
L2NsaWVudC9jaWZzZ2xvYi5oICAgfCAgMSArCiBmcy9zbWIvY2xpZW50L3NtYjJpbm9kZS5jICB8
ICAxICsKIGZzL3NtYi9jbGllbnQvc21iMm9wcy5jICAgIHwgIDQgKysrKwogZnMvc21iL2NsaWVu
dC9zbWIycGR1LmMgICAgfCAxMCArKysrKysrKy0tCiA1IGZpbGVzIGNoYW5nZWQsIDE1IGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jYWNo
ZWRfZGlyLmMgYi9mcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuYwppbmRleCAxZGFlYjU3MTRmYWEu
LjNkZTUwNDdhN2ZmOSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmMKKysr
IGIvZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmMKQEAgLTI0Miw2ICsyNDIsNyBAQCBpbnQgb3Bl
bl9jYWNoZWRfZGlyKHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJ
CS5kZXNpcmVkX2FjY2VzcyA9ICBGSUxFX1JFQURfREFUQSB8IEZJTEVfUkVBRF9BVFRSSUJVVEVT
LAogCQkuZGlzcG9zaXRpb24gPSBGSUxFX09QRU4sCiAJCS5maWQgPSBwZmlkLAorCQkucmVwbGF5
ID0gISEocmV0cmllcyksCiAJfTsKIAogCXJjID0gU01CMl9vcGVuX2luaXQodGNvbiwgc2VydmVy
LApkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oIGIvZnMvc21iL2NsaWVudC9j
aWZzZ2xvYi5oCmluZGV4IGM4NmE3MmM5ZDllYy4uNTNjNzVjZmIzM2FiIDEwMDY0NAotLS0gYS9m
cy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKKysrIGIvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCkBA
IC0xMzc4LDYgKzEzNzgsNyBAQCBzdHJ1Y3QgY2lmc19vcGVuX3Bhcm1zIHsKIAlzdHJ1Y3QgY2lm
c19maWQgKmZpZDsKIAl1bW9kZV90IG1vZGU7CiAJYm9vbCByZWNvbm5lY3Q6MTsKKwlib29sIHJl
cGxheToxOyAvKiBpbmRpY2F0ZXMgdGhhdCB0aGlzIG9wZW4gaXMgZm9yIGEgcmVwbGF5ICovCiB9
OwogCiBzdHJ1Y3QgY2lmc19maWQgewpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIyaW5v
ZGUuYyBiL2ZzL3NtYi9jbGllbnQvc21iMmlub2RlLmMKaW5kZXggMDU4MThjZDZkOTMyLi42M2Iw
NGY5NzE4NGEgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMmlub2RlLmMKKysrIGIvZnMv
c21iL2NsaWVudC9zbWIyaW5vZGUuYwpAQCAtMTI4LDYgKzEyOCw3IEBAIHN0YXRpYyBpbnQgc21i
Ml9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0
Y29uLAogCW9wbG9jayA9IFNNQjJfT1BMT0NLX0xFVkVMX05PTkU7CiAJbnVtX3Jxc3QgPSAwOwog
CXNlcnZlciA9IGNpZnNfcGlja19jaGFubmVsKHNlcyk7CisJb3Bhcm1zLT5yZXBsYXkgPSAhIShy
ZXRyaWVzKTsKIAogCXZhcnMgPSBremFsbG9jKHNpemVvZigqdmFycyksIEdGUF9BVE9NSUMpOwog
CWlmICh2YXJzID09IE5VTEwpCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYyBi
L2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jCmluZGV4IDc1NWYxYzY2YjU3My4uNmIzYzM4NGVhZDBk
IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYworKysgYi9mcy9zbWIvY2xpZW50
L3NtYjJvcHMuYwpAQCAtMTIwNCw2ICsxMjA0LDcgQEAgc21iMl9zZXRfZWEoY29uc3QgdW5zaWdu
ZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJLmRpc3Bvc2l0aW9uID0gRklM
RV9PUEVOLAogCQkuY3JlYXRlX29wdGlvbnMgPSBjaWZzX2NyZWF0ZV9vcHRpb25zKGNpZnNfc2Is
IDApLAogCQkuZmlkID0gJmZpZCwKKwkJLnJlcGxheSA9ICEhKHJldHJpZXMpLAogCX07CiAKIAly
YyA9IFNNQjJfb3Blbl9pbml0KHRjb24sIHNlcnZlciwKQEAgLTE1NjksNiArMTU3MCw3IEBAIHNt
YjJfaW9jdGxfcXVlcnlfaW5mbyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLAogCQkuZGlzcG9zaXRp
b24gPSBGSUxFX09QRU4sCiAJCS5jcmVhdGVfb3B0aW9ucyA9IGNpZnNfY3JlYXRlX29wdGlvbnMo
Y2lmc19zYiwgY3JlYXRlX29wdGlvbnMpLAogCQkuZmlkID0gJmZpZCwKKwkJLnJlcGxheSA9ICEh
KHJldHJpZXMpLAogCX07CiAKIAlpZiAocWkuZmxhZ3MgJiBQQVNTVEhSVV9GU0NUTCkgewpAQCAt
MjI5NSw2ICsyMjk3LDcgQEAgc21iMl9xdWVyeV9kaXJfZmlyc3QoY29uc3QgdW5zaWduZWQgaW50
IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJLmRpc3Bvc2l0aW9uID0gRklMRV9PUEVO
LAogCQkuY3JlYXRlX29wdGlvbnMgPSBjaWZzX2NyZWF0ZV9vcHRpb25zKGNpZnNfc2IsIDApLAog
CQkuZmlkID0gZmlkLAorCQkucmVwbGF5ID0gISEocmV0cmllcyksCiAJfTsKIAogCXJjID0gU01C
Ml9vcGVuX2luaXQodGNvbiwgc2VydmVyLApAQCAtMjY4MSw2ICsyNjg0LDcgQEAgc21iMl9xdWVy
eV9pbmZvX2NvbXBvdW5kKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24g
KnRjb24sCiAJCS5kaXNwb3NpdGlvbiA9IEZJTEVfT1BFTiwKIAkJLmNyZWF0ZV9vcHRpb25zID0g
Y2lmc19jcmVhdGVfb3B0aW9ucyhjaWZzX3NiLCAwKSwKIAkJLmZpZCA9ICZmaWQsCisJCS5yZXBs
YXkgPSAhIShyZXRyaWVzKSwKIAl9OwogCiAJcmMgPSBTTUIyX29wZW5faW5pdCh0Y29uLCBzZXJ2
ZXIsCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYyBiL2ZzL3NtYi9jbGllbnQv
c21iMnBkdS5jCmluZGV4IDQwODVjZTI3ZmQzOC4uNjA4ZWUwNTQ5MWUyIDEwMDY0NAotLS0gYS9m
cy9zbWIvY2xpZW50L3NtYjJwZHUuYworKysgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwpAQCAt
MjQwNCw4ICsyNDA0LDEzIEBAIGNyZWF0ZV9kdXJhYmxlX3YyX2J1ZihzdHJ1Y3QgY2lmc19vcGVu
X3Bhcm1zICpvcGFybXMpCiAJICovCiAJYnVmLT5kY29udGV4dC5UaW1lb3V0ID0gY3B1X3RvX2xl
MzIob3Bhcm1zLT50Y29uLT5oYW5kbGVfdGltZW91dCk7CiAJYnVmLT5kY29udGV4dC5GbGFncyA9
IGNwdV90b19sZTMyKFNNQjJfREhBTkRMRV9GTEFHX1BFUlNJU1RFTlQpOwotCWdlbmVyYXRlX3Jh
bmRvbV91dWlkKGJ1Zi0+ZGNvbnRleHQuQ3JlYXRlR3VpZCk7Ci0JbWVtY3B5KHBmaWQtPmNyZWF0
ZV9ndWlkLCBidWYtPmRjb250ZXh0LkNyZWF0ZUd1aWQsIDE2KTsKKworCS8qIGZvciByZXBsYXks
IHdlIHNob3VsZCBub3Qgb3ZlcndyaXRlIHRoZSBleGlzdGluZyBjcmVhdGUgZ3VpZCAqLworCWlm
ICghb3Bhcm1zLT5yZXBsYXkpIHsKKwkJZ2VuZXJhdGVfcmFuZG9tX3V1aWQoYnVmLT5kY29udGV4
dC5DcmVhdGVHdWlkKTsKKwkJbWVtY3B5KHBmaWQtPmNyZWF0ZV9ndWlkLCBidWYtPmRjb250ZXh0
LkNyZWF0ZUd1aWQsIDE2KTsKKwl9IGVsc2UKKwkJbWVtY3B5KGJ1Zi0+ZGNvbnRleHQuQ3JlYXRl
R3VpZCwgcGZpZC0+Y3JlYXRlX2d1aWQsIDE2KTsKIAogCS8qIFNNQjJfQ1JFQVRFX0RVUkFCTEVf
SEFORExFX1JFUVVFU1QgaXMgIkRIMlEiICovCiAJYnVmLT5OYW1lWzBdID0gJ0QnOwpAQCAtMzE0
Miw2ICszMTQ3LDcgQEAgU01CMl9vcGVuKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBj
aWZzX29wZW5fcGFybXMgKm9wYXJtcywgX19sZTE2ICpwYXRoLAogCS8qIHJlaW5pdGlhbGl6ZSBm
b3IgcG9zc2libGUgcmVwbGF5ICovCiAJZmxhZ3MgPSAwOwogCXNlcnZlciA9IGNpZnNfcGlja19j
aGFubmVsKHNlcyk7CisJb3Bhcm1zLT5yZXBsYXkgPSAhIShyZXRyaWVzKTsKIAogCWNpZnNfZGJn
KEZZSSwgImNyZWF0ZS9vcGVuXG4iKTsKIAlpZiAoIXNlcyB8fCAhc2VydmVyKQotLSAKMi40MC4x
Cgo=
--00000000000084dffd06110111c4--
