Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02442EBBAD
	for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 12:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758197406; cv=none; b=pKXK1hE66LZhBxJ90CW/+rOBQHdgiJH2jiYCPcsspf5/bTWBnw1cNMgkAsQaIeaIPcV7sTsEiL7YakAJ/w4c8UHnKDbpTRHnW0QDF8YK6drhaqnuXNwH4aEHnDrF/vS6xNTzXIMYf89YzYpEMSD2AQQx64Zck4Yt692X1p8XCDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758197406; c=relaxed/simple;
	bh=QSqvJtgl4eopOSUqTRvMkIz8oZWp1TBgC1q8PAQo18k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=apeR4kF7AHVmLpKV4ezRZjlnPrkHlu2o/5EjESOepF0ssx8UFGSq1aF1JhFc3drM/ZDDAEXOFy7+Bv+TMN36T5hzm2ElAGIKZ6UiiCAVl1J8+4pOFE9kJxg3i52AsFfqIpfZTjXfAAqiBggQmYNNUyFGUj53ckv3JPPfgEh0bFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HDu0vEOU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XWAhpwkg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HDu0vEOU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XWAhpwkg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HDu0vEOU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XWAhpwkg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HDu0vEOU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XWAhpwkg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A46732119D;
	Thu, 18 Sep 2025 12:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758197400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CSXiXWIx4LxyK8oDORMkAwUU+C2TOcCaT7/HhuEgrWQ=;
	b=HDu0vEOUxQIhkAJQdpXaodh02TG8EMSqynuyH8+j6351HIPC45GNSXomq+Krq1o+H10KCT
	8xL4rRrhPsOALqexAdLY9rnuCbNZ+BPCPVsbL7EE254tee8JnYRI5ilyKFuMmSqhl8GMIz
	nEH89C7av9uaQiNlC/ldYY0ey4Of+To=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758197400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CSXiXWIx4LxyK8oDORMkAwUU+C2TOcCaT7/HhuEgrWQ=;
	b=XWAhpwkg9FoNS1CPNcvdAF6RwRX0p4XHdbbXVfWuwcNJpixUwEYBlB2V8OEEz26mrdWZwf
	Kd31hoC/iDzK+sAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758197400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CSXiXWIx4LxyK8oDORMkAwUU+C2TOcCaT7/HhuEgrWQ=;
	b=HDu0vEOUxQIhkAJQdpXaodh02TG8EMSqynuyH8+j6351HIPC45GNSXomq+Krq1o+H10KCT
	8xL4rRrhPsOALqexAdLY9rnuCbNZ+BPCPVsbL7EE254tee8JnYRI5ilyKFuMmSqhl8GMIz
	nEH89C7av9uaQiNlC/ldYY0ey4Of+To=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758197400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CSXiXWIx4LxyK8oDORMkAwUU+C2TOcCaT7/HhuEgrWQ=;
	b=XWAhpwkg9FoNS1CPNcvdAF6RwRX0p4XHdbbXVfWuwcNJpixUwEYBlB2V8OEEz26mrdWZwf
	Kd31hoC/iDzK+sAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32B4413A51;
	Thu, 18 Sep 2025 12:09:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C6q/Opf2y2iGEgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 18 Sep 2025 12:09:59 +0000
Date: Thu, 18 Sep 2025 09:09:57 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>, 
	Frank Sorenson <sorenson@redhat.com>, David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: fix filename matching of deferred files
Message-ID: <jpjp7nokw5gdynw7i64zpg3ns2og5z7blsunpqr5yzyrb3dqq3@nvstycufnglk>
References: <20250917190322.765293-1-pc@manguebit.org>
 <v4g2cku4itpiqvfiy6aktcey5rjc2jt5kcoknf36hm45p3nxgu@wb5ho6aoy6dc>
 <CAH2r5mu3fyGd11tf983tvYiKB_Yn8FS3tTQL97HzQKybspgUXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAH2r5mu3fyGd11tf983tvYiKB_Yn8FS3tTQL97HzQKybspgUXA@mail.gmail.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80

On 09/17, Steve French wrote:
>minor cosmetic change done to the patch (see attached)
>
>from:
>   if (cfile->dentry =3D=3D dentry &&
>to:
>   if ((cfile->dentry =3D=3D dentry) &&

IMHO those only makes sense if for either correctness or easier
understanding, e.g.:

>  if (x && (y || z))

or

>  if ((x & y) && z)

Otherwise it only adds pollution and maybe confusion to the code.
Example of complete unnecessary extra wrapping in file.c and cifsacl.c
(but there are several others I've seen around):

>  if ((!open_file->invalidHandle)) {

>  if ((!ctsid) || (!cwsid))


My 2c only, up to you of course.


Cheers,

Enzo

>On Wed, Sep 17, 2025 at 2:15=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de=
> wrote:
>>
>> On 09/17, Paulo Alcantara wrote:
>> >Fix the following case where the client would end up closing both
>> >deferred files (foo.tmp & foo) after unlink(foo) due to strstr() call
>> >in cifs_close_deferred_file_under_dentry():
>> >
>> >  fd1 =3D openat(AT_FDCWD, "foo", O_WRONLY|O_CREAT|O_TRUNC, 0666);
>> >  fd2 =3D openat(AT_FDCWD, "foo.tmp", O_WRONLY|O_CREAT|O_TRUNC, 0666);
>> >  close(fd1);
>> >  close(fd2);
>> >  unlink("foo");
>> >
>> >Fixes: e3fc065682eb ("cifs: Deferred close performance improvements")
>> >Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>> >Cc: Enzo Matsumiya <ematsumiya@suse.de>
>> >Cc: Frank Sorenson <sorenson@redhat.com>
>> >Cc: David Howells <dhowells@redhat.com>
>> >Cc: linux-cifs@vger.kernel.org
>> >---
>> > fs/smb/client/cifsproto.h |  4 ++--
>> > fs/smb/client/inode.c     |  6 +++---
>> > fs/smb/client/misc.c      | 36 +++++++++++++++---------------------
>> > 3 files changed, 20 insertions(+), 26 deletions(-)
>> >
>> >diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
>> >index c34c533b2efa..e8fba98690ce 100644
>> >--- a/fs/smb/client/cifsproto.h
>> >+++ b/fs/smb/client/cifsproto.h
>> >@@ -312,8 +312,8 @@ extern void cifs_close_deferred_file(struct cifsIno=
deInfo *cifs_inode);
>> >
>> > extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon);
>> >
>> >-extern void cifs_close_deferred_file_under_dentry(struct cifs_tcon *ci=
fs_tcon,
>> >-                              const char *path);
>> >+void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
>> >+                                         struct dentry *dentry);
>> >
>> > extern void cifs_mark_open_handles_for_deleted_file(struct inode *inod=
e,
>> >                               const char *path);
>> >diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
>> >index 11d442e8b3d6..1703f1285d36 100644
>> >--- a/fs/smb/client/inode.c
>> >+++ b/fs/smb/client/inode.c
>> >@@ -1984,7 +1984,7 @@ static int __cifs_unlink(struct inode *dir, struc=
t dentry *dentry, bool sillyren
>> >       }
>> >
>> >       netfs_wait_for_outstanding_io(inode);
>> >-      cifs_close_deferred_file_under_dentry(tcon, full_path);
>> >+      cifs_close_deferred_file_under_dentry(tcon, dentry);
>> > #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>> >       if (cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
>> >                               le64_to_cpu(tcon->fsUnixInfo.Capability)=
)) {
>> >@@ -2538,10 +2538,10 @@ cifs_rename2(struct mnt_idmap *idmap, struct in=
ode *source_dir,
>> >               goto cifs_rename_exit;
>> >       }
>> >
>> >-      cifs_close_deferred_file_under_dentry(tcon, from_name);
>> >+      cifs_close_deferred_file_under_dentry(tcon, source_dentry);
>> >       if (d_inode(target_dentry) !=3D NULL) {
>> >               netfs_wait_for_outstanding_io(d_inode(target_dentry));
>> >-              cifs_close_deferred_file_under_dentry(tcon, to_name);
>> >+              cifs_close_deferred_file_under_dentry(tcon, target_dentr=
y);
>> >       }
>> >
>> >       rc =3D cifs_do_rename(xid, source_dentry, from_name, target_dent=
ry,
>> >diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
>> >index da23cc12a52c..350542d57249 100644
>> >--- a/fs/smb/client/misc.c
>> >+++ b/fs/smb/client/misc.c
>> >@@ -832,33 +832,28 @@ cifs_close_all_deferred_files(struct cifs_tcon *t=
con)
>> >               kfree(tmp_list);
>> >       }
>> > }
>> >-void
>> >-cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const ch=
ar *path)
>> >+
>> >+void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
>> >+                                         struct dentry *dentry)
>> > {
>> >-      struct cifsFileInfo *cfile;
>> >       struct file_list *tmp_list, *tmp_next_list;
>> >-      void *page;
>> >-      const char *full_path;
>> >+      struct cifsFileInfo *cfile;
>> >       LIST_HEAD(file_head);
>> >
>> >-      page =3D alloc_dentry_path();
>> >       spin_lock(&tcon->open_file_lock);
>> >       list_for_each_entry(cfile, &tcon->openFileList, tlist) {
>> >-              full_path =3D build_path_from_dentry(cfile->dentry, page=
);
>> >-              if (strstr(full_path, path)) {
>> >-                      if (delayed_work_pending(&cfile->deferred)) {
>> >-                              if (cancel_delayed_work(&cfile->deferred=
)) {
>> >-                                      spin_lock(&CIFS_I(d_inode(cfile-=
>dentry))->deferred_lock);
>> >-                                      cifs_del_deferred_close(cfile);
>> >-                                      spin_unlock(&CIFS_I(d_inode(cfil=
e->dentry))->deferred_lock);
>> >+              if (cfile->dentry =3D=3D dentry &&
>> >+                  delayed_work_pending(&cfile->deferred) &&
>> >+                  cancel_delayed_work(&cfile->deferred)) {
>> >+                      spin_lock(&CIFS_I(d_inode(cfile->dentry))->defer=
red_lock);
>> >+                      cifs_del_deferred_close(cfile);
>> >+                      spin_unlock(&CIFS_I(d_inode(cfile->dentry))->def=
erred_lock);
>> >
>> >-                                      tmp_list =3D kmalloc(sizeof(stru=
ct file_list), GFP_ATOMIC);
>> >-                                      if (tmp_list =3D=3D NULL)
>> >-                                              break;
>> >-                                      tmp_list->cfile =3D cfile;
>> >-                                      list_add_tail(&tmp_list->list, &=
file_head);
>> >-                              }
>> >-                      }
>> >+                      tmp_list =3D kmalloc(sizeof(struct file_list), G=
FP_ATOMIC);
>> >+                      if (tmp_list =3D=3D NULL)
>> >+                              break;
>> >+                      tmp_list->cfile =3D cfile;
>> >+                      list_add_tail(&tmp_list->list, &file_head);
>> >               }
>> >       }
>> >       spin_unlock(&tcon->open_file_lock);
>> >@@ -868,7 +863,6 @@ cifs_close_deferred_file_under_dentry(struct cifs_t=
con *tcon, const char *path)
>> >               list_del(&tmp_list->list);
>> >               kfree(tmp_list);
>> >       }
>> >-      free_dentry_path(page);
>> > }
>> >
>> > /*
>>
>> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
>>
>>
>> Cheers,
>>
>> Enzo
>
>
>
>--=20
>Thanks,
>
>Steve


