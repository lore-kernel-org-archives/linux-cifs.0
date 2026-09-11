Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463B13CAA50
	for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 12:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789129941; cv=pass; b=ietSLJ26yDEzNmmgW5wpgiZuhVBzdTqKb6e3dZW4TQvBQXnwd9kIakVyf5FzgUpc4Bzn4qXQMA77C40vP/ZUxx0bmedafZnQLnUyIypG/3JHfYj6206gR6uedsX1ae18XkUBOOtq0ztyGudP6/a+X525kyaZQWFTIn11D1sEkr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789129941; c=relaxed/simple;
	bh=GfGY13tQsBIBtgNZNUsiTH0qNAGdLQBQm0DmdUH5d+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uvcBIoT9M1tHsdVZ7quutjf1oeJO+ZkciWvd5nGBfBjpWsUhDx85wS/jceACgiF0kOfFhBclgJR1yH3/Iz1/SQPthKgI5zcpC2JAYl9tVwQ3skiMn3e4uj1eVIE4sV8plOemEOQ6UqG1vVyC7jqB9qDz+vP+JEs+SSKiPxwLZeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GDXP98Tj; arc=pass smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GDXP98Tj"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-86c0e4dd49cso7502977b3.3
        for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 05:32:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789129923; cv=none;
        d=google.com; s=arc-20260327;
        b=mwkSFIYbDs+uGabjPYZ8QdDVIDbh8bR/yWuSgZnlvXPvgHo6e8W5bHhNZBeiwH6/3/
         rhW9eGhwrPj4tsDi+jWSxOrqd6d7tfwJgJ6hCGRkKNAg7+Ixk6DkBbYrkYXEcImHOXxa
         n/bkj1TT/tGgASUVPyiS6U7sgKhuViBOLKo3JFEeqBj3jGLXzoMHRaHTvsBSVTAfHMgs
         qQbGGF5Yt/IDJ2LE0TbwNJr2vg/VoWbEYrGAiukicHpkGxtwd7f5774RWsZ736rGmE6e
         8DgKyIb6i5/cJ1Wi0H45xnDN0OqlNVRaK0POC/Ag8nIn7jRFr9fWr9fC4rOtEc0PwenV
         MgGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=caD0AN8MUeIKYzz7vLP38Y8N+w2mnj0GbXgaghHlPqA=;
        fh=xhq3gBIfMpqLiGKjYG4p3G+zAer86O10T8tkghm1jas=;
        b=pyW8pwpm+RIR0/VgT5BnZZn1vElfKNBHp9D8QKB6IVY1qGkpar38sKic3aThan7YKp
         RmF3oKTHQXwMopv3GVZlgl9ulC8e5/nkEDDL2Dw2hnNZa1GILj6ke1jKKP6p35RqglYW
         L4vdXCHY/xzQ3/91QOnVvF7D9JxcCee/g294PLNO//djtW4mMq9dl2fY6MZzEAa9mU2D
         EWtXly6SNiyVrVsWHs8YOK7vI++KnZqezuMH1twFoCi+x6nnShecfogeLV0/7hE306Uu
         0nSYFeNN05dgQDQ6Zn6fsvMgWbnY/xm+6XEu/Nc23xJmUUsHco2itWDqrK8ZnT7iloPN
         VwOg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789129923; x=1789734723; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=caD0AN8MUeIKYzz7vLP38Y8N+w2mnj0GbXgaghHlPqA=;
        b=GDXP98TjbTn7dENk33rIPd0Ksa4F7AqCVKcln4PHWCVvu879DL88cLai6ObgxzmMAh
         TkdvpcbJFO8zkdQJkS+Gu4GTALJFYfGCNFfg5fLsBiSufeWjgxnXJ776BbQOgihAjJ29
         4oFe2Ft+sy1SzkwQ7kBKDD0wbIYqLSVJRW47OtOz3ejBZ4wF4nacIAmlTyXcSnTDnXSb
         BfxI//fsRzBmFIUt5uWD/ktmd530t6ZNMchhNjN0DY7tSnjlevGO2+J+hXPQu6c5ij7X
         4kW8+ANcv/5rm7RVciGrVvcfD4VJObQn33JSlBK9WgtEGfJ8axi3H3YV31M2tBPTppvJ
         z8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789129923; x=1789734723;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=caD0AN8MUeIKYzz7vLP38Y8N+w2mnj0GbXgaghHlPqA=;
        b=izgLmxQVkQqnWzbXllXh2TPMjyNkaKLboIwUpJ/VXphKyDWUhlgdCicohaMKnbjJa2
         frHj+n1fsS9BDhYN/n2n2PGph6H/rnA5OaTcipDnGgxJow97jXW5Gcaqd3q8Bf2ql6Mv
         rPipFJC5Bp6tb8ymR+x7oI623q+jbriOetNvbP06q0D09XklLf1eKWmUQVkQNvFFLoAX
         zVwwM7rgrZ24fCAZa1bAh9XakFkLpx6CpduXjG/P3KdUFGpWuDUC1UuHDBN4b5ePf8O8
         m3+PMyof3tnlXhYEnWo0tDp+g3iC69Hs7kvNAzxEuDdoa5Z17MN9srGqEn4ceVPTsAz7
         rhaw==
X-Gm-Message-State: AFuF++lxDe5Btv1ASemmbfI6QEh0yP4o23TCl/si6qyosNGWuhFxraxg
	sdBGNqjYJhgLVFXYveJIIkZ0enubZNbsx8yB/njDEHwGWrn1ngroYvYCJTGsCyYmckJxs+RXp/P
	khYlnlCVxUukVJGRT0mhLN0eRGn116cU=
X-Gm-Gg: AYBFou3Eon+GJBPwnz4ceJPVmAUsStN84mw5U6/vwvH4clDObEGUiWRYBAwpwwolZTT
	qlBKiGnb5QyhPjET0sDFnj1mEtKRT0xyhe4O6HjN+E4u5YlHxt6Ate80nWKocxVFqwrivs4U/yE
	V6ZlLYacZJa7ZKapqAnFt9LVQDDQjgotTSfpL6X+/rXJYFaoQO7RkkWvFxRxTs11oajOk/SyZzk
	hTSVBhLanpS2iEvHO4eOrvKMhrr2t4K3GLeEEVPQfeqXV+6BdrUV/Zw4qU8SrXAnWI+PZn/Qi5h
	8YRAulNZMvcZo7decq5ViGHuS4ojs6IoEc+ObOGj1A4n3FVijWcM
X-Received: by 2002:a05:690e:4547:10b0:671:23de:14d9 with SMTP id
 956f58d0204a3-67124574c68mr1013303d50.31.1789129923374; Fri, 11 Sep 2026
 05:32:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910051649.3806214-1-april.cardenas@canonical.com>
In-Reply-To: <20260910051649.3806214-1-april.cardenas@canonical.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Fri, 11 Sep 2026 12:31:52 +0000
X-Gm-Features: AcwNN1WbsQN-BPoDZ6fJmFMQpIFFBjaprIPiBLElv0YUz9QVJuPOcZeQ_WLxtig
Message-ID: <CAGypqWxKokujjRHmrJ=iSM4vhqmmTxAPy_GrQQDmeZk271+Rmg@mail.gmail.com>
Subject: Re: [PATCH] smb/client: send lease break ACKs thru correct session
 for multiuser mounts
To: April Cardenas <april.cardenas@canonical.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, linkinjeon@kernel.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 5:17=E2=80=AFAM April Cardenas
<april.cardenas@canonical.com> wrote:
>
> Currently, when cifs_oplock_break handles a break request from the server
> it searches for the appropriate tlink to handle the request
> but incorrectly uses the current fsuid as the search key, eventually
> causing read errors for users with multiuser mounts on NetApp.
> Fix this by using the tlink from the cfile struct instead to respond
> through the correct session.
>
> As breaks are handled in a worker thread, the current fsuid
> isn't guaranteed to match the session that the break is intended for.
> This means that cifs_sb_tlink may search the rbtree using the wrong fsuid=
,
> and return a tlink with an incorrect session than
> the lease break was intended for. As a result, the breaks
> may be ACKed through an incorrect session.
>
> While it seems that Samba/Windows Servers 2016-2025 ignore this as long a=
s
> the lease key is correct, we ran into a case where if you're using
> NetApp ONTAP or Azure NetApp Files they will reject the ACK
> and return `STATUS_LOCK_NOT_GRANTED` errors on any future read requests
> a user may initiate through their still held open file handle,
> and the server will eventually close the file.
>
> In the dmesg logs, the user may see errors like these:
>
> CIFS: Status code returned 0xc0000128 STATUS_FILE_CLOSED
> CIFS: VFS: Send error in read =3D -9
>
> With a multiuser mount using NetApp, this issue is really easy
> for users to hit on a wide variety of kernel versions
> by attempting to copy a file from the share
> to the local machine through GNOME Files/Nautilus.
> This copy will always result in Nautilus throwing
> a `Bad File Descriptor` error to the user and fail.
> With this fix, you can copy files through Nautilus without issue.
>
> From looking at the traces, it seems that glib will
> open the file first, and call listxattr before actually attempting
> to copy the file data. The listxattr call always triggers a break,
> causing the copy to fail.
>
> The proposed fix returns to the way the client grabbed the tlink before
> commit e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break").
>
> The bulk of that commit (checking for list empty) remains untouched, and
> I think the change to using cifs_sb_tlink was intended to avoid a
> NULL/ERR deference on the tlink as well as update the reference count.
>
> I believe this fix should preserve those safety properties, but of course
> I'd appreciate any corrections here.
>
> Fixes: e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break")
> Cc: stable@vger.kernel.org
> Signed-off-by: April Cardenas <april.cardenas@canonical.com>
> ---
>  fs/smb/client/file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 1aa4844f8b8a..0d428517f454 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -3354,8 +3354,8 @@ void cifs_oplock_break(struct work_struct *work)
>         wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
>                         TASK_UNINTERRUPTIBLE);
>
> -       tlink =3D cifs_sb_tlink(cifs_sb);
> -       if (IS_ERR(tlink)) {
> +       tlink =3D cifs_get_tlink(cfile->tlink);
> +       if (IS_ERR_OR_NULL(tlink)) {
>                 /* drop the reference taken when the break was queued */
>                 _cifsFileInfo_put(cfile, false /* do not wait for ourself=
 */, false);
>                 goto out;

LGTM. Reviewed-by: Bharath S M <bharathsm@microsoft.com>
