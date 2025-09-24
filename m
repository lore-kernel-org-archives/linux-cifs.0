Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D80E2D97AC;
	Wed, 24 Sep 2025 10:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758710848; cv=none; b=de34oThp40Xi+9HZPzcOUrcLJ+mRYvg5KmiFnDNhI63+GoPdlK7/CMRCrN+clPFUGr8QDDuzon8qOeISG98OfR63dVHBOLUuXeWZN8nP4m2rAlVCylahQ7VjwL43kRFV85XcdTuSmrX43FP7jWyGqRpk7rAlDHmKuXtubtTvo9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758710848; c=relaxed/simple;
	bh=oEY3mV3Fmr5BdfFXvs0fiC3rE40Cy4VL3WvgmAYOcfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5M2lRdBMABlimY5Ei8XRWbcQlahY63f5yYtJfiaUSy2RyXJNjsNeDGtDqa+UNdx3lRgXzs3edVmBzPjg0f4L2ccicwn2H6fwjVggB0+uCsfO9tHplSAd8b+vJLPzrUDJcgRuK83Q9ZRyfRpD9OhBcX6OKIkTVdGH8ewxEd0dPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uq7TyQmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uq7TyQmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A081C4CEE7;
	Wed, 24 Sep 2025 10:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758710847;
	bh=oEY3mV3Fmr5BdfFXvs0fiC3rE40Cy4VL3WvgmAYOcfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uq7TyQmWj2TcBNqYhlL5etjU1jIKM+0Y2eSsdaxyUoW4LBthSrgrSrAQj7j+wPIcx
	 dlQXg5jh5CMB2EgBeiOwVeCZj+9a4Ev6rOOoIrwOqv1BpcKC6EuopVF/+ytPc1KvgB
	 MOAH4Go/X42r/pz0TNdMZ3736Bvvkzq7Bkbs4Of4crZHSKIZDjtYQALEQr9oHjzm1d
	 aTsp01MMToxlrejLyymRZpKggolUWmTTEaKRICNApn3R0Qe1Lm641/x9UESXDrtZ6j
	 PJYsk6f4fZHFArnBM90jWEjcAmNPUpkgmd9akoLyvA2mRGLnrKxSsDcHoobpSHVfae
	 d1Tz1vvppi+LA==
Received: by pali.im (Postfix)
	id 17431731; Wed, 24 Sep 2025 12:47:24 +0200 (CEST)
Date: Wed, 24 Sep 2025 12:47:23 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/35] cifs: Improve SMB2+ stat() to work also for paths
 in DELETE_PENDING state
Message-ID: <20250924104723.aoyxdx2kb6ytempg@pali>
References: <20250831123602.14037-1-pali@kernel.org>
 <20250831123602.14037-9-pali@kernel.org>
 <CAH2r5muVP5NuZFfsCWDYhCKATDyeaD2cpXgC3=zNh+3T_zO1Mg@mail.gmail.com>
 <20250920174217.h5neq5yllnbvgn5a@pali>
 <CAH2r5msWy9K04gMAQhfxsV-_TVhkTWL--oOGy_aQ78HCuibR0g@mail.gmail.com>
 <20250920180024.qo5m2oiniiwrxxyw@pali>
 <CAH2r5mvVpUY5T+qNhHMnub1ktiwhgUjr3ZfyL7UCMyiO_Ay9mw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mvVpUY5T+qNhHMnub1ktiwhgUjr3ZfyL7UCMyiO_Ay9mw@mail.gmail.com>
User-Agent: NeoMutt/20180716

So here are some scenarios which do not work on current mainline:

1.

- Windows client open file "path", let it open and issue delete 
- Linux client issue mkdir "path".

Linux mkdir fails on error "No such file or directory". ENOENT for mkdir
means that some directory component does not exist. But everything
exists, issue is that DELETE_PENDING on path is incorrectly translated,
it has to be anything than ENOENT.

2.

- Any client open file "path" and let it open
- Linux client issue rm "path" && mkdir "path"

Linux rm pass (no error), but mkdir fails. That is a problem because on
successful "rm" call, the path has to be free for new inode creation of
that name.

My silly rename changes are fixing this scenario as they detects that
some other client has open the "path" and instead of setting the path
into delete pending state, my changes do: "rename path to _unique_name_"
and "set delete pending on _unique_name_". With this steps, followup
"mkdir path" will pass because "path" is free after the rename.


3.

- Windows client open directory "path" and let it open
- Linux client issue "rm -rf path" and then call "touch path"

Same issue as in 2. As the "path" is being open, its directory inode
cannot be immediately removed and stay in delete pending state.
My silly rename changes detects also that directory itself is opened and
do rename dir to _unique_name_ before issuing the final rmdir.
So followup touch will pass as the path name was released.


All these scenarios request at least two clients. I'm not familiar with
xfstests, even if they supports something like using two different
clients.


On Saturday 20 September 2025 13:04:13 Steve French wrote:
> > The last changes which enable silly rename
> 
> There were LOTS of good discussions about silly rename at the test
> event last week (and what other FS do and what Apple client does etc.)
> and some testing of it, but would be helpful to know which scenarios
> your silly rename changes fix (example tests) that don't work with
> current mainline (and as mentioned earlier even better if this fixes
> an industry standard test, like one of xfstests - still plenty of
> those to fix)
> 
> On Sat, Sep 20, 2025 at 1:00 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > Reordering is very problematic. Majority of patches depends on previous
> > patches, that is why I sent them in a patch series to make it visible
> > in which order they needs to be applied.
> >
> > I tried to avoid sending "one big change". So I split that my one big
> > change into lot of smaller (even that they depend each on other) to make
> > it easier to review. And the result is this patch series.
> >
> > The last changes which enable silly rename depends on the implementation
> > in all previous changes in this patch series, so basically this patch
> > series should be treated as fixing one unlink/rmdir feature.
> >
> > There are also smb1 change, but majority of them is related to silly
> > rename which as explained in commit message is smb1-only and after this
> > patch series, code is modified and reused also for smb3.
> >
> > On Saturday 20 September 2025 12:48:45 Steve French wrote:
> > > Also would be helpful to reorder these in order by importance. Prioritize:
> > > 1) those fixes that are useful for current mounts (e.g. smb3.1.1 or
> > > smb3) and matter for servers that are still commonly used (obviously
> > > SMB1 fixes are low priority, unless small and obvious fixes)
> > > 2) those that fix bugs that can be shown with simple test script
> > > 3) those that improve "best effort" Linux semantics
> > > 4) those that are large and hard to review are prioritized lower
> > >
> > > On Sat, Sep 20, 2025 at 12:42 PM Pali Rohár <pali@kernel.org> wrote:
> > > >
> > > > Commits in this patch series needs to be applied in the order.
> > > > So this patch does not apply without the previous dependent. It would
> > > > not apply alone.
> > > >
> > > > I sent this patch series about month ago, so maybe the patch series
> > > > needs to be rebased, I can look at it in next days.
> > > >
> > > > On Saturday 20 September 2025 12:26:40 Steve French wrote:
> > > > > This patch doesn't apply to current mainline - can you update it?
> > > > >
> > > > > On Sun, Aug 31, 2025 at 7:36 AM Pali Rohár <pali@kernel.org> wrote:
> > > > > >
> > > > > > Paths in DELETE_PENDING state cannot be opened at all. So standard way of
> > > > > > querying path attributes for this case is not possible.
> > > > > >
> > > > > > There is an alternative way how to query limited information about file
> > > > > > over SMB2+ dialects without opening file itself. It is by opening the
> > > > > > parent directory, querying specific child with filled search filter and
> > > > > > asking for attributes for that child.
> > > > > >
> > > > > > Implement this fallback when standard case in smb2_query_path_info fails
> > > > > > with STATUS_DELETE_PENDING error and stat was asked for path which is not
> > > > > > top level one (because top level does not have parent directory at all).
> > > > > >
> > > > > > Depends on "cifs: Change translation of STATUS_DELETE_PENDING to -EBUSY".
> > > > > >
> > > > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > > > > ---
> > > > > >  fs/smb/client/cifsglob.h  |   1 +
> > > > > >  fs/smb/client/smb2glob.h  |   1 +
> > > > > >  fs/smb/client/smb2inode.c | 177 +++++++++++++++++++++++++++++++++++++-
> > > > > >  3 files changed, 176 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > > > > > index e6830ab3a546..0ecf4988664e 100644
> > > > > > --- a/fs/smb/client/cifsglob.h
> > > > > > +++ b/fs/smb/client/cifsglob.h
> > > > > > @@ -2337,6 +2337,7 @@ struct smb2_compound_vars {
> > > > > >         struct smb_rqst rqst[MAX_COMPOUND];
> > > > > >         struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> > > > > >         struct kvec qi_iov;
> > > > > > +       struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
> > > > > >         struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
> > > > > >         struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
> > > > > >         struct kvec close_iov;
> > > > > > diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.h
> > > > > > index 224495322a05..1cb219605e75 100644
> > > > > > --- a/fs/smb/client/smb2glob.h
> > > > > > +++ b/fs/smb/client/smb2glob.h
> > > > > > @@ -39,6 +39,7 @@ enum smb2_compound_ops {
> > > > > >         SMB2_OP_GET_REPARSE,
> > > > > >         SMB2_OP_QUERY_WSL_EA,
> > > > > >         SMB2_OP_OPEN_QUERY,
> > > > > > +       SMB2_OP_QUERY_DIRECTORY,
> > > > > >  };
> > > > > >
> > > > > >  /* Used when constructing chained read requests. */
> > > > > > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > > > > > index 2a0316c514e4..460e75614ef1 100644
> > > > > > --- a/fs/smb/client/smb2inode.c
> > > > > > +++ b/fs/smb/client/smb2inode.c
> > > > > > @@ -176,6 +176,9 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
> > > > > >                             struct kvec *out_iov, int *out_buftype, struct dentry *dentry)
> > > > > >  {
> > > > > >
> > > > > > +       bool has_cifs_mount_server_inum = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM;
> > > > > > +       struct smb2_query_directory_req *qd_rqst = NULL;
> > > > > > +       struct smb2_query_directory_rsp *qd_rsp = NULL;
> > > > > >         struct smb2_create_rsp *create_rsp = NULL;
> > > > > >         struct smb2_query_info_rsp *qi_rsp = NULL;
> > > > > >         struct smb2_compound_vars *vars = NULL;
> > > > > > @@ -344,6 +347,41 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
> > > > > >                         trace_smb3_posix_query_info_compound_enter(xid, tcon->tid,
> > > > > >                                                                    ses->Suid, full_path);
> > > > > >                         break;
> > > > > > +               case SMB2_OP_QUERY_DIRECTORY:
> > > > > > +                       rqst[num_rqst].rq_iov = &vars->qd_iov[0];
> > > > > > +                       rqst[num_rqst].rq_nvec = SMB2_QUERY_DIRECTORY_IOV_SIZE;
> > > > > > +
> > > > > > +                       rc = SMB2_query_directory_init(xid,
> > > > > > +                                                      tcon,
> > > > > > +                                                      server,
> > > > > > +                                                      &rqst[num_rqst],
> > > > > > +                                                      cfile ?
> > > > > > +                                                       cfile->fid.persistent_fid : COMPOUND_FID,
> > > > > > +                                                      cfile ?
> > > > > > +                                                       cfile->fid.volatile_fid : COMPOUND_FID,
> > > > > > +                                                      0,
> > > > > > +                                                      has_cifs_mount_server_inum ?
> > > > > > +                                                       SMB_FIND_FILE_ID_FULL_DIR_INFO :
> > > > > > +                                                       SMB_FIND_FILE_FULL_DIRECTORY_INFO);
> > > > > > +                       if (!rc) {
> > > > > > +                               /*
> > > > > > +                                * Change the default search wildcard pattern '*'
> > > > > > +                                * to the requested file name stored in in_iov[i]
> > > > > > +                                * and request for only one single entry.
> > > > > > +                                */
> > > > > > +                               qd_rqst = rqst[num_rqst].rq_iov[0].iov_base;
> > > > > > +                               qd_rqst->Flags |= SMB2_RETURN_SINGLE_ENTRY;
> > > > > > +                               qd_rqst->FileNameLength = cpu_to_le16(in_iov[i].iov_len);
> > > > > > +                               rqst[num_rqst].rq_iov[1] = in_iov[i];
> > > > > > +                       }
> > > > > > +                       if (!rc && (!cfile || num_rqst > 1)) {
> > > > > > +                               smb2_set_next_command(tcon, &rqst[num_rqst]);
> > > > > > +                               smb2_set_related(&rqst[num_rqst]);
> > > > > > +                       } else if (rc) {
> > > > > > +                               goto finished;
> > > > > > +                       }
> > > > > > +                       num_rqst++;
> > > > > > +                       break;
> > > > > >                 case SMB2_OP_DELETE:
> > > > > >                         trace_smb3_delete_enter(xid, tcon->tid, ses->Suid, full_path);
> > > > > >                         break;
> > > > > > @@ -730,6 +768,64 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
> > > > > >                                 trace_smb3_posix_query_info_compound_done(xid, tcon->tid,
> > > > > >                                                                           ses->Suid);
> > > > > >                         break;
> > > > > > +               case SMB2_OP_QUERY_DIRECTORY:
> > > > > > +                       if (rc == 0) {
> > > > > > +                               qd_rsp = (struct smb2_query_directory_rsp *)
> > > > > > +                                       rsp_iov[i + 1].iov_base;
> > > > > > +                               rc = smb2_validate_iov(le16_to_cpu(qd_rsp->OutputBufferOffset),
> > > > > > +                                                      le32_to_cpu(qd_rsp->OutputBufferLength),
> > > > > > +                                                      &rsp_iov[i + 1],
> > > > > > +                                                      has_cifs_mount_server_inum ?
> > > > > > +                                                       sizeof(SEARCH_ID_FULL_DIR_INFO) :
> > > > > > +                                                       sizeof(FILE_FULL_DIRECTORY_INFO));
> > > > > > +                       }
> > > > > > +                       if (rc == 0) {
> > > > > > +                               /*
> > > > > > +                                * Both SEARCH_ID_FULL_DIR_INFO and FILE_FULL_DIRECTORY_INFO
> > > > > > +                                * have same member offsets except the UniqueId and FileName.
> > > > > > +                                */
> > > > > > +                               SEARCH_ID_FULL_DIR_INFO *si =
> > > > > > +                                       (SEARCH_ID_FULL_DIR_INFO *)qd_rsp->Buffer;
> > > > > > +
> > > > > > +                               idata = in_iov[i + 1].iov_base;
> > > > > > +                               idata->fi.CreationTime = si->CreationTime;
> > > > > > +                               idata->fi.LastAccessTime = si->LastAccessTime;
> > > > > > +                               idata->fi.LastWriteTime = si->LastWriteTime;
> > > > > > +                               idata->fi.ChangeTime = si->ChangeTime;
> > > > > > +                               idata->fi.Attributes = si->ExtFileAttributes;
> > > > > > +                               idata->fi.AllocationSize = si->AllocationSize;
> > > > > > +                               idata->fi.EndOfFile = si->EndOfFile;
> > > > > > +                               idata->fi.EASize = si->EaSize;
> > > > > > +                               idata->fi.Directory =
> > > > > > +                                       !!(le32_to_cpu(si->ExtFileAttributes) & ATTR_DIRECTORY);
> > > > > > +                               /*
> > > > > > +                                * UniqueId is present only in struct SEARCH_ID_FULL_DIR_INFO.
> > > > > > +                                * It is not present in struct FILE_FULL_DIRECTORY_INFO.
> > > > > > +                                * struct SEARCH_ID_FULL_DIR_INFO was requested only when
> > > > > > +                                * CIFS_MOUNT_SERVER_INUM is set.
> > > > > > +                                */
> > > > > > +                               if (has_cifs_mount_server_inum)
> > > > > > +                                       idata->fi.IndexNumber = si->UniqueId;
> > > > > > +                               /*
> > > > > > +                                * Do not change idata->fi.NumberOfLinks to correctly
> > > > > > +                                * trigger the CIFS_FATTR_UNKNOWN_NLINK flag.
> > > > > > +                                */
> > > > > > +                               /*
> > > > > > +                                * Do not change idata->fi.DeletePending as we do not know if
> > > > > > +                                * the entry is in the delete pending state. SMB2 QUERY_DIRECTORY
> > > > > > +                                * at any level does not provide this information.
> > > > > > +                                */
> > > > > > +                       }
> > > > > > +                       SMB2_query_directory_free(&rqst[num_rqst++]);
> > > > > > +                       if (rc)
> > > > > > +                               trace_smb3_query_dir_err(xid,
> > > > > > +                                       cfile ? cfile->fid.persistent_fid : COMPOUND_FID,
> > > > > > +                                       tcon->tid, ses->Suid, 0, 0, rc);
> > > > > > +                       else
> > > > > > +                               trace_smb3_query_dir_done(xid,
> > > > > > +                                       cfile ? cfile->fid.persistent_fid : COMPOUND_FID,
> > > > > > +                                       tcon->tid, ses->Suid, 0, 0);
> > > > > > +                       break;
> > > > > >                 case SMB2_OP_DELETE:
> > > > > >                         if (rc)
> > > > > >                                 trace_smb3_delete_err(xid, tcon->tid, ses->Suid, rc);
> > > > > > @@ -1090,9 +1186,9 @@ int smb2_query_path_info(const unsigned int xid,
> > > > > >                 break;
> > > > > >         case -EREMOTE:
> > > > > >                 break;
> > > > > > -       default:
> > > > > > -               if (hdr->Status != STATUS_OBJECT_NAME_INVALID)
> > > > > > -                       break;
> > > > > > +       }
> > > > > > +
> > > > > > +       if (hdr->Status == STATUS_OBJECT_NAME_INVALID) {
> > > > > >                 rc2 = cifs_inval_name_dfs_link_error(xid, tcon, cifs_sb,
> > > > > >                                                      full_path, &islink);
> > > > > >                 if (rc2) {
> > > > > > @@ -1101,6 +1197,81 @@ int smb2_query_path_info(const unsigned int xid,
> > > > > >                 }
> > > > > >                 if (islink)
> > > > > >                         rc = -EREMOTE;
> > > > > > +       } else if (hdr->Status == STATUS_DELETE_PENDING && full_path[0]) {
> > > > > > +               /*
> > > > > > +                * If SMB2 OPEN/CREATE fails with STATUS_DELETE_PENDING error,
> > > > > > +                * it means that the path is in delete pending state and it is
> > > > > > +                * not possible to open it until some other client clears delete
> > > > > > +                * pending state or all other clients close all opened handles
> > > > > > +                * to that path.
> > > > > > +                *
> > > > > > +                * There is an alternative way how to query limited information
> > > > > > +                * about path which is in delete pending state still suitable
> > > > > > +                * for the stat() syscall. It is by opening the parent directory,
> > > > > > +                * querying specific child with filled search filer and asking
> > > > > > +                * for attributes for that child.
> > > > > > +                */
> > > > > > +
> > > > > > +               char *parent_path;
> > > > > > +               const char *basename;
> > > > > > +               __le16 *basename_utf16;
> > > > > > +               int basename_utf16_len;
> > > > > > +               struct cifsFileInfo *parent_cfile;
> > > > > > +
> > > > > > +               basename = strrchr(full_path, CIFS_DIR_SEP(cifs_sb));
> > > > > > +               if (basename) {
> > > > > > +                       parent_path = kstrndup(full_path, basename - full_path, GFP_KERNEL);
> > > > > > +                       basename++;
> > > > > > +               } else {
> > > > > > +                       parent_path = kstrdup("", GFP_KERNEL);
> > > > > > +                       basename = full_path;
> > > > > > +               }
> > > > > > +
> > > > > > +               if (!parent_path) {
> > > > > > +                       rc = -ENOMEM;
> > > > > > +                       goto out;
> > > > > > +               }
> > > > > > +
> > > > > > +               basename_utf16 = cifs_convert_path_to_utf16(basename, cifs_sb);
> > > > > > +               if (!basename_utf16) {
> > > > > > +                       kfree(parent_path);
> > > > > > +                       rc = -ENOMEM;
> > > > > > +                       goto out;
> > > > > > +               }
> > > > > > +
> > > > > > +               basename_utf16_len = 2 * UniStrnlen((wchar_t *)basename_utf16, PATH_MAX);
> > > > > > +
> > > > > > +retry_query_directory:
> > > > > > +               num_cmds = 1;
> > > > > > +               cmds[0] = SMB2_OP_QUERY_DIRECTORY;
> > > > > > +               in_iov[0].iov_base = basename_utf16;
> > > > > > +               in_iov[0].iov_len = basename_utf16_len;
> > > > > > +               in_iov[1].iov_base = data;
> > > > > > +               in_iov[1].iov_len = sizeof(*data);
> > > > > > +               oparms = CIFS_OPARMS(cifs_sb, tcon, parent_path, FILE_READ_DATA,
> > > > > > +                                    FILE_OPEN, CREATE_NOT_FILE, ACL_NO_MODE);
> > > > > > +               cifs_get_readable_path(tcon, parent_path, &parent_cfile);
> > > > > > +               free_rsp_iov(out_iov, out_buftype, ARRAY_SIZE(out_iov));
> > > > > > +               rc = smb2_compound_op(xid, tcon, cifs_sb, parent_path,
> > > > > > +                                     &oparms, in_iov, cmds, num_cmds,
> > > > > > +                                     parent_cfile, out_iov, out_buftype, NULL);
> > > > > > +               if (rc == -EOPNOTSUPP && (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
> > > > > > +                       /*
> > > > > > +                        * If querying of server inode numbers is not supported
> > > > > > +                        * but is enabled, then disable it and try again.
> > > > > > +                        */
> > > > > > +                       cifs_autodisable_serverino(cifs_sb);
> > > > > > +                       goto retry_query_directory;
> > > > > > +               }
> > > > > > +
> > > > > > +               kfree(parent_path);
> > > > > > +               kfree(basename_utf16);
> > > > > > +
> > > > > > +               hdr = out_iov[0].iov_base;
> > > > > > +               if (!hdr || out_buftype[0] == CIFS_NO_BUFFER)
> > > > > > +                       goto out;
> > > > > > +
> > > > > > +               data->fi.DeletePending = 1; /* This is code path for STATUS_DELETE_PENDING. */
> > > > > >         }
> > > > > >
> > > > > >  out:
> > > > > > --
> > > > > > 2.20.1
> > > > > >
> > > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
