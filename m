Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120432F5B;
	Sat, 20 Sep 2025 18:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758391720; cv=none; b=rMqKWAmCHeIUNWqPeIoxV4tF/jJ6iZcVWG+n2rGJHHSMKt7urvyMiy1/x1reu3XShDM2dGjQjv3pzLsgs/F7+wrjOoQlqQnBXdVvrtczKyJ02KKAQ8KaQEvaq7D8GYCS/ZInPLHoj5/5SJHF90rx9G89Vdxd7mFip/iZw55qVU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758391720; c=relaxed/simple;
	bh=WkeIjJo1LIUAC3tBoV3rkpO8cTac/3jJSEgqxa6muJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mgcE4X/F/vIcufjgSjCsAuV0u5c2iNiuv3hnIVL7jVGQQ7EB0y5+Ex/gW7Sy6p12AsuAM9c2sYW+UHIUhp4XbgHVHBRh64amdxYkk1/oxCddLpjurMb6pobkm15RiccHDmrRHSZ0TzqSV3EkeyYI54iJNuGv+XhwSy2+rPEK94c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9pBrSFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9pBrSFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46232C4CEEB;
	Sat, 20 Sep 2025 18:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758391719;
	bh=WkeIjJo1LIUAC3tBoV3rkpO8cTac/3jJSEgqxa6muJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J9pBrSFfY4O4mG1XHcGBSfeX3kKixhVu1vUU0c63jcyIZhsoNbObshcKu6wP5AQJk
	 Fk+zHgUr0ltqBbjQ2CczBZCMOONQNcl5YI1kVdCo88Z09x0ARqnIlyejugeyslBC5l
	 alwSBVCWc50snte60vxKZxxyBh/Kt/igSZW28JUco5IF4SFgBzgYivjVoKpSmndIzq
	 csWcTIPN8byQwXNtereEri0jTKhNOAnirVOMqBJs+HBQHi5EzLsARBOm6dl7D+lEZf
	 GGF9SIIJCilQ5Qi3CQzhVksWWrZP5PniBHZN5wURSmQGHOHxh/f/p0gCicUoa90DwC
	 wQsOMxl+Aql6Q==
Received: by pali.im (Postfix)
	id D51105DA; Sat, 20 Sep 2025 20:08:35 +0200 (CEST)
Date: Sat, 20 Sep 2025 20:08:35 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/35] cifs: Improve SMB2+ stat() to work also for paths
 in DELETE_PENDING state
Message-ID: <20250920180835.5awqcyf6hzfdvjlq@pali>
References: <20250831123602.14037-1-pali@kernel.org>
 <20250831123602.14037-9-pali@kernel.org>
 <CAH2r5muRF1=H=acG2d0jVayW2fp0_V-5-0=Mx+8+VDRD-2oK4A@mail.gmail.com>
 <20250920173630.rjajntsu2sy72fys@pali>
 <CAH2r5muDLtJ1hFPmmuRydyh64ovU5Lg5z1WUhCrAo9iCEG33KQ@mail.gmail.com>
 <CAH2r5ms_ufxY-J+8rQ3X5zToe6aQv9B1ZorRuk86CAfW_VBzQw@mail.gmail.com>
 <20250920175108.6t45aw5d2dekplor@pali>
 <CAH2r5mvX9rgen9JsesaT+CdBUJcbqcBesjc9jELT3pUNRKQc7g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mvX9rgen9JsesaT+CdBUJcbqcBesjc9jELT3pUNRKQc7g@mail.gmail.com>
User-Agent: NeoMutt/20180716

See email "[PATCH 00/35]". I already wrote there 5 different simple test
scenarios which shows what is wrong and how the scenarios are fixed and
changed after this patch series. Direct email link to archive:
https://lore.kernel.org/linux-cifs/20250831123602.14037-1-pali@kernel.org/
Also in followup email I sent pcaps which Stefan Metzmacher asked from me.
In case there is missing in those scenarios, please let me know, I could
try to extend or provide more information. I do not have xfstests, I'm
not very familiar with it.

On Saturday 20 September 2025 12:56:07 Steve French wrote:
> > "We can use tricks like marking file as hidden and silly rename to make
> them less visible" --> This is exactly what is the whole patch series is
> doing.
> 
> It wasn't at all clear looking at the 35 patches ... which fix
> rename/delete cases for current (smb3.1.1) mounts on current mainline.
> Would be helpful if a few simple test examples to show examples of
> where current mainline fails to Windows or Samba or ksmbd or Azure
> etc.   Even better is if you could show which xfstests that it fixes
> that break with current mainline
> 
> On Sat, Sep 20, 2025 at 12:51 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > "We can use tricks like marking file as hidden and silly rename to make
> > them less visible" --> This is exactly what is the whole patch series is
> > doing.
> >
> > On Saturday 20 September 2025 12:40:14 Steve French wrote:
> > > We can use tricks like marking file as hidden and silly rename to make
> > > them less visible - but focus on the closest we can get to expected
> > > Linux behavior
> > >
> > > On Sat, Sep 20, 2025 at 12:39 PM Steve French <smfrench@gmail.com> wrote:
> > > >
> > > > As long as we don't break any Linux apps - we need to return file not
> > > > found or equivalent when a file is in delete pending in every path
> > > > that we can (if we have some places that incorrectly show the file,
> > > > the better solution is to hide it there, not to break more Linux apps
> > > > by showing a file which has been deleted/silly-renamed
> > > >
> > > > On Sat, Sep 20, 2025 at 12:36 PM Pali Rohár <pali@kernel.org> wrote:
> > > > >
> > > > > The point is that the directory entry is not deleted yet. It is present
> > > > > in the readdir() output. For Linux apps the file not found should be
> > > > > returned when the directory entry disappear (from readdir()). I wrote
> > > > > few test scenarios in cover letter of the patch series, which covers
> > > > > this.
> > > > >
> > > > > On Saturday 20 September 2025 12:14:00 Steve French wrote:
> > > > > > This looks confusing, like it is wrong for Linux apps - when Linux
> > > > > > queries a file that is deleted (but still open by some other process)
> > > > > > it should get the equivalent of file not found or at least an error -
> > > > > > you aren't supposed to allow path based calls on a file which has a
> > > > > > pending delete or that would break Linux apps.
> > > > > >
> > > > > > On Sun, Aug 31, 2025 at 7:36 AM Pali Rohár <pali@kernel.org> wrote:
> > > > > > >
> > > > > > > Paths in DELETE_PENDING state cannot be opened at all. So standard way of
> > > > > > > querying path attributes for this case is not possible.
> > > > > > >
> > > > > > > There is an alternative way how to query limited information about file
> > > > > > > over SMB2+ dialects without opening file itself. It is by opening the
> > > > > > > parent directory, querying specific child with filled search filter and
> > > > > > > asking for attributes for that child.
> > > > > > >
> > > > > > > Implement this fallback when standard case in smb2_query_path_info fails
> > > > > > > with STATUS_DELETE_PENDING error and stat was asked for path which is not
> > > > > > > top level one (because top level does not have parent directory at all).
> > > > > > >
> > > > > > > Depends on "cifs: Change translation of STATUS_DELETE_PENDING to -EBUSY".
> > > > > > >
> > > > > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > > > > > ---
> > > > > > >  fs/smb/client/cifsglob.h  |   1 +
> > > > > > >  fs/smb/client/smb2glob.h  |   1 +
> > > > > > >  fs/smb/client/smb2inode.c | 177 +++++++++++++++++++++++++++++++++++++-
> > > > > > >  3 files changed, 176 insertions(+), 3 deletions(-)
> > > > > > >
> > > > > > > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > > > > > > index e6830ab3a546..0ecf4988664e 100644
> > > > > > > --- a/fs/smb/client/cifsglob.h
> > > > > > > +++ b/fs/smb/client/cifsglob.h
> > > > > > > @@ -2337,6 +2337,7 @@ struct smb2_compound_vars {
> > > > > > >         struct smb_rqst rqst[MAX_COMPOUND];
> > > > > > >         struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> > > > > > >         struct kvec qi_iov;
> > > > > > > +       struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
> > > > > > >         struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
> > > > > > >         struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
> > > > > > >         struct kvec close_iov;
> > > > > > > diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.h
> > > > > > > index 224495322a05..1cb219605e75 100644
> > > > > > > --- a/fs/smb/client/smb2glob.h
> > > > > > > +++ b/fs/smb/client/smb2glob.h
> > > > > > > @@ -39,6 +39,7 @@ enum smb2_compound_ops {
> > > > > > >         SMB2_OP_GET_REPARSE,
> > > > > > >         SMB2_OP_QUERY_WSL_EA,
> > > > > > >         SMB2_OP_OPEN_QUERY,
> > > > > > > +       SMB2_OP_QUERY_DIRECTORY,
> > > > > > >  };
> > > > > > >
> > > > > > >  /* Used when constructing chained read requests. */
> > > > > > > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > > > > > > index 2a0316c514e4..460e75614ef1 100644
> > > > > > > --- a/fs/smb/client/smb2inode.c
> > > > > > > +++ b/fs/smb/client/smb2inode.c
> > > > > > > @@ -176,6 +176,9 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
> > > > > > >                             struct kvec *out_iov, int *out_buftype, struct dentry *dentry)
> > > > > > >  {
> > > > > > >
> > > > > > > +       bool has_cifs_mount_server_inum = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM;
> > > > > > > +       struct smb2_query_directory_req *qd_rqst = NULL;
> > > > > > > +       struct smb2_query_directory_rsp *qd_rsp = NULL;
> > > > > > >         struct smb2_create_rsp *create_rsp = NULL;
> > > > > > >         struct smb2_query_info_rsp *qi_rsp = NULL;
> > > > > > >         struct smb2_compound_vars *vars = NULL;
> > > > > > > @@ -344,6 +347,41 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
> > > > > > >                         trace_smb3_posix_query_info_compound_enter(xid, tcon->tid,
> > > > > > >                                                                    ses->Suid, full_path);
> > > > > > >                         break;
> > > > > > > +               case SMB2_OP_QUERY_DIRECTORY:
> > > > > > > +                       rqst[num_rqst].rq_iov = &vars->qd_iov[0];
> > > > > > > +                       rqst[num_rqst].rq_nvec = SMB2_QUERY_DIRECTORY_IOV_SIZE;
> > > > > > > +
> > > > > > > +                       rc = SMB2_query_directory_init(xid,
> > > > > > > +                                                      tcon,
> > > > > > > +                                                      server,
> > > > > > > +                                                      &rqst[num_rqst],
> > > > > > > +                                                      cfile ?
> > > > > > > +                                                       cfile->fid.persistent_fid : COMPOUND_FID,
> > > > > > > +                                                      cfile ?
> > > > > > > +                                                       cfile->fid.volatile_fid : COMPOUND_FID,
> > > > > > > +                                                      0,
> > > > > > > +                                                      has_cifs_mount_server_inum ?
> > > > > > > +                                                       SMB_FIND_FILE_ID_FULL_DIR_INFO :
> > > > > > > +                                                       SMB_FIND_FILE_FULL_DIRECTORY_INFO);
> > > > > > > +                       if (!rc) {
> > > > > > > +                               /*
> > > > > > > +                                * Change the default search wildcard pattern '*'
> > > > > > > +                                * to the requested file name stored in in_iov[i]
> > > > > > > +                                * and request for only one single entry.
> > > > > > > +                                */
> > > > > > > +                               qd_rqst = rqst[num_rqst].rq_iov[0].iov_base;
> > > > > > > +                               qd_rqst->Flags |= SMB2_RETURN_SINGLE_ENTRY;
> > > > > > > +                               qd_rqst->FileNameLength = cpu_to_le16(in_iov[i].iov_len);
> > > > > > > +                               rqst[num_rqst].rq_iov[1] = in_iov[i];
> > > > > > > +                       }
> > > > > > > +                       if (!rc && (!cfile || num_rqst > 1)) {
> > > > > > > +                               smb2_set_next_command(tcon, &rqst[num_rqst]);
> > > > > > > +                               smb2_set_related(&rqst[num_rqst]);
> > > > > > > +                       } else if (rc) {
> > > > > > > +                               goto finished;
> > > > > > > +                       }
> > > > > > > +                       num_rqst++;
> > > > > > > +                       break;
> > > > > > >                 case SMB2_OP_DELETE:
> > > > > > >                         trace_smb3_delete_enter(xid, tcon->tid, ses->Suid, full_path);
> > > > > > >                         break;
> > > > > > > @@ -730,6 +768,64 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
> > > > > > >                                 trace_smb3_posix_query_info_compound_done(xid, tcon->tid,
> > > > > > >                                                                           ses->Suid);
> > > > > > >                         break;
> > > > > > > +               case SMB2_OP_QUERY_DIRECTORY:
> > > > > > > +                       if (rc == 0) {
> > > > > > > +                               qd_rsp = (struct smb2_query_directory_rsp *)
> > > > > > > +                                       rsp_iov[i + 1].iov_base;
> > > > > > > +                               rc = smb2_validate_iov(le16_to_cpu(qd_rsp->OutputBufferOffset),
> > > > > > > +                                                      le32_to_cpu(qd_rsp->OutputBufferLength),
> > > > > > > +                                                      &rsp_iov[i + 1],
> > > > > > > +                                                      has_cifs_mount_server_inum ?
> > > > > > > +                                                       sizeof(SEARCH_ID_FULL_DIR_INFO) :
> > > > > > > +                                                       sizeof(FILE_FULL_DIRECTORY_INFO));
> > > > > > > +                       }
> > > > > > > +                       if (rc == 0) {
> > > > > > > +                               /*
> > > > > > > +                                * Both SEARCH_ID_FULL_DIR_INFO and FILE_FULL_DIRECTORY_INFO
> > > > > > > +                                * have same member offsets except the UniqueId and FileName.
> > > > > > > +                                */
> > > > > > > +                               SEARCH_ID_FULL_DIR_INFO *si =
> > > > > > > +                                       (SEARCH_ID_FULL_DIR_INFO *)qd_rsp->Buffer;
> > > > > > > +
> > > > > > > +                               idata = in_iov[i + 1].iov_base;
> > > > > > > +                               idata->fi.CreationTime = si->CreationTime;
> > > > > > > +                               idata->fi.LastAccessTime = si->LastAccessTime;
> > > > > > > +                               idata->fi.LastWriteTime = si->LastWriteTime;
> > > > > > > +                               idata->fi.ChangeTime = si->ChangeTime;
> > > > > > > +                               idata->fi.Attributes = si->ExtFileAttributes;
> > > > > > > +                               idata->fi.AllocationSize = si->AllocationSize;
> > > > > > > +                               idata->fi.EndOfFile = si->EndOfFile;
> > > > > > > +                               idata->fi.EASize = si->EaSize;
> > > > > > > +                               idata->fi.Directory =
> > > > > > > +                                       !!(le32_to_cpu(si->ExtFileAttributes) & ATTR_DIRECTORY);
> > > > > > > +                               /*
> > > > > > > +                                * UniqueId is present only in struct SEARCH_ID_FULL_DIR_INFO.
> > > > > > > +                                * It is not present in struct FILE_FULL_DIRECTORY_INFO.
> > > > > > > +                                * struct SEARCH_ID_FULL_DIR_INFO was requested only when
> > > > > > > +                                * CIFS_MOUNT_SERVER_INUM is set.
> > > > > > > +                                */
> > > > > > > +                               if (has_cifs_mount_server_inum)
> > > > > > > +                                       idata->fi.IndexNumber = si->UniqueId;
> > > > > > > +                               /*
> > > > > > > +                                * Do not change idata->fi.NumberOfLinks to correctly
> > > > > > > +                                * trigger the CIFS_FATTR_UNKNOWN_NLINK flag.
> > > > > > > +                                */
> > > > > > > +                               /*
> > > > > > > +                                * Do not change idata->fi.DeletePending as we do not know if
> > > > > > > +                                * the entry is in the delete pending state. SMB2 QUERY_DIRECTORY
> > > > > > > +                                * at any level does not provide this information.
> > > > > > > +                                */
> > > > > > > +                       }
> > > > > > > +                       SMB2_query_directory_free(&rqst[num_rqst++]);
> > > > > > > +                       if (rc)
> > > > > > > +                               trace_smb3_query_dir_err(xid,
> > > > > > > +                                       cfile ? cfile->fid.persistent_fid : COMPOUND_FID,
> > > > > > > +                                       tcon->tid, ses->Suid, 0, 0, rc);
> > > > > > > +                       else
> > > > > > > +                               trace_smb3_query_dir_done(xid,
> > > > > > > +                                       cfile ? cfile->fid.persistent_fid : COMPOUND_FID,
> > > > > > > +                                       tcon->tid, ses->Suid, 0, 0);
> > > > > > > +                       break;
> > > > > > >                 case SMB2_OP_DELETE:
> > > > > > >                         if (rc)
> > > > > > >                                 trace_smb3_delete_err(xid, tcon->tid, ses->Suid, rc);
> > > > > > > @@ -1090,9 +1186,9 @@ int smb2_query_path_info(const unsigned int xid,
> > > > > > >                 break;
> > > > > > >         case -EREMOTE:
> > > > > > >                 break;
> > > > > > > -       default:
> > > > > > > -               if (hdr->Status != STATUS_OBJECT_NAME_INVALID)
> > > > > > > -                       break;
> > > > > > > +       }
> > > > > > > +
> > > > > > > +       if (hdr->Status == STATUS_OBJECT_NAME_INVALID) {
> > > > > > >                 rc2 = cifs_inval_name_dfs_link_error(xid, tcon, cifs_sb,
> > > > > > >                                                      full_path, &islink);
> > > > > > >                 if (rc2) {
> > > > > > > @@ -1101,6 +1197,81 @@ int smb2_query_path_info(const unsigned int xid,
> > > > > > >                 }
> > > > > > >                 if (islink)
> > > > > > >                         rc = -EREMOTE;
> > > > > > > +       } else if (hdr->Status == STATUS_DELETE_PENDING && full_path[0]) {
> > > > > > > +               /*
> > > > > > > +                * If SMB2 OPEN/CREATE fails with STATUS_DELETE_PENDING error,
> > > > > > > +                * it means that the path is in delete pending state and it is
> > > > > > > +                * not possible to open it until some other client clears delete
> > > > > > > +                * pending state or all other clients close all opened handles
> > > > > > > +                * to that path.
> > > > > > > +                *
> > > > > > > +                * There is an alternative way how to query limited information
> > > > > > > +                * about path which is in delete pending state still suitable
> > > > > > > +                * for the stat() syscall. It is by opening the parent directory,
> > > > > > > +                * querying specific child with filled search filer and asking
> > > > > > > +                * for attributes for that child.
> > > > > > > +                */
> > > > > > > +
> > > > > > > +               char *parent_path;
> > > > > > > +               const char *basename;
> > > > > > > +               __le16 *basename_utf16;
> > > > > > > +               int basename_utf16_len;
> > > > > > > +               struct cifsFileInfo *parent_cfile;
> > > > > > > +
> > > > > > > +               basename = strrchr(full_path, CIFS_DIR_SEP(cifs_sb));
> > > > > > > +               if (basename) {
> > > > > > > +                       parent_path = kstrndup(full_path, basename - full_path, GFP_KERNEL);
> > > > > > > +                       basename++;
> > > > > > > +               } else {
> > > > > > > +                       parent_path = kstrdup("", GFP_KERNEL);
> > > > > > > +                       basename = full_path;
> > > > > > > +               }
> > > > > > > +
> > > > > > > +               if (!parent_path) {
> > > > > > > +                       rc = -ENOMEM;
> > > > > > > +                       goto out;
> > > > > > > +               }
> > > > > > > +
> > > > > > > +               basename_utf16 = cifs_convert_path_to_utf16(basename, cifs_sb);
> > > > > > > +               if (!basename_utf16) {
> > > > > > > +                       kfree(parent_path);
> > > > > > > +                       rc = -ENOMEM;
> > > > > > > +                       goto out;
> > > > > > > +               }
> > > > > > > +
> > > > > > > +               basename_utf16_len = 2 * UniStrnlen((wchar_t *)basename_utf16, PATH_MAX);
> > > > > > > +
> > > > > > > +retry_query_directory:
> > > > > > > +               num_cmds = 1;
> > > > > > > +               cmds[0] = SMB2_OP_QUERY_DIRECTORY;
> > > > > > > +               in_iov[0].iov_base = basename_utf16;
> > > > > > > +               in_iov[0].iov_len = basename_utf16_len;
> > > > > > > +               in_iov[1].iov_base = data;
> > > > > > > +               in_iov[1].iov_len = sizeof(*data);
> > > > > > > +               oparms = CIFS_OPARMS(cifs_sb, tcon, parent_path, FILE_READ_DATA,
> > > > > > > +                                    FILE_OPEN, CREATE_NOT_FILE, ACL_NO_MODE);
> > > > > > > +               cifs_get_readable_path(tcon, parent_path, &parent_cfile);
> > > > > > > +               free_rsp_iov(out_iov, out_buftype, ARRAY_SIZE(out_iov));
> > > > > > > +               rc = smb2_compound_op(xid, tcon, cifs_sb, parent_path,
> > > > > > > +                                     &oparms, in_iov, cmds, num_cmds,
> > > > > > > +                                     parent_cfile, out_iov, out_buftype, NULL);
> > > > > > > +               if (rc == -EOPNOTSUPP && (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
> > > > > > > +                       /*
> > > > > > > +                        * If querying of server inode numbers is not supported
> > > > > > > +                        * but is enabled, then disable it and try again.
> > > > > > > +                        */
> > > > > > > +                       cifs_autodisable_serverino(cifs_sb);
> > > > > > > +                       goto retry_query_directory;
> > > > > > > +               }
> > > > > > > +
> > > > > > > +               kfree(parent_path);
> > > > > > > +               kfree(basename_utf16);
> > > > > > > +
> > > > > > > +               hdr = out_iov[0].iov_base;
> > > > > > > +               if (!hdr || out_buftype[0] == CIFS_NO_BUFFER)
> > > > > > > +                       goto out;
> > > > > > > +
> > > > > > > +               data->fi.DeletePending = 1; /* This is code path for STATUS_DELETE_PENDING. */
> > > > > > >         }
> > > > > > >
> > > > > > >  out:
> > > > > > > --
> > > > > > > 2.20.1
> > > > > > >
> > > > > > >
> > > > > >
> > > > > >
> > > > > > --
> > > > > > Thanks,
> > > > > >
> > > > > > Steve
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
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
