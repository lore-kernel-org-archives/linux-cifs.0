Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F81A18EAB;
	Sun, 29 Sep 2024 21:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727647134; cv=none; b=DfOQVRkkjUv8YBhvZdXg7xcZ2SpOEsAzX3X6cNJBjgoXPnkf7qVv9isbhvgwUGbMDAe6ZeNAGgkwvnMGSQfG0ICy+dQuDojfc56DMFhNPRhTI6b0HfSE0SBm1QKOUkG6bwibkC5Weh6og1cK0c3WT21wR12uk94FEf0lQAlPelw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727647134; c=relaxed/simple;
	bh=yNAehFEJDlgSU/hZCEo3rHn0auD4rx+gJ+SCeidkRbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ladZlDYFmATAxvu+MeY20SUI6S+GQCspDkjEy+H7s4PsLQL1j1M5Y6vvOu2WLK8h2kQLFYNJITe8ITBK3xYSqPhK2dQ8UrhSIeHDdFEOIaxw4XkrQotbKwoOFfPKlgRCZZmAPHARp+hNQaD+jKMbysmGZe8rfSmef9e6w9F2azk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tXVEikIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tXVEikIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0C7C4CEC5;
	Sun, 29 Sep 2024 21:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727647133;
	bh=yNAehFEJDlgSU/hZCEo3rHn0auD4rx+gJ+SCeidkRbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tXVEikIyaBoQDLzSLbBs16NOo2eA2hdoAGw7t4jRFQincnwtEvZRhcY4PeG028mhL
	 OSbAxsHcm24vv2OYG88KxSf5wUgta4GbJPYZ1Cgx1lJxNR2Ic1df8AFG9qMNL6Pvaq
	 0VcaeihJr80xsLoNw/wPnLyLeQ2ysMoh+TuoreXX8R99fDqoQ6zjeef07Z4tAeewkH
	 yaXTsvPzfO16olhBP7ktQjcBBSRDQaXVjcTeYZKZd+Gbu9rpqelmHSBe743WTYKKpX
	 5R3+BJRxElB00JJFygdQn9Laj+u7UtTuNdIteeq61iqWsKLRUzq/fg6NCc4UsPwz6a
	 4cwB2YcczV+Kw==
Received: by pali.im (Postfix)
	id BEF9B872; Sun, 29 Sep 2024 23:58:47 +0200 (CEST)
Date: Sun, 29 Sep 2024 23:58:47 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] cifs: Fix parsing native symlinks directory/file type
Message-ID: <20240929215847.yn2xeilk4uabm453@pali>
References: <20240929185053.10554-1-pali@kernel.org>
 <20240929185053.10554-6-pali@kernel.org>
 <CAH2r5mu6Uikd+72DVjKs9A10xn4yy3Db7ZftC_W_9jWTZ_W0SA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mu6Uikd+72DVjKs9A10xn4yy3Db7ZftC_W_9jWTZ_W0SA@mail.gmail.com>
User-Agent: NeoMutt/20180716

I was thinking about it and in my opinion this should be OK. If you
create native directory symlink on Windows via mklink /D and it would
point to file, then trying to open that symlink fails on Windows with
error. On Linux if you append slash to symlink target path then opening
it will fail if the target path is file. On Linux the symlink pointing
to directory may have trailing slash but it not required.

But testing by other people would be useful to confirm that there is not
some hidden issue.

On Sunday 29 September 2024 16:47:48 Steve French wrote:
> obvious question is ... is there any risk that this could break POSIX
> behavior when creating server side symlinks (ie not using mfsylmlinks,
> but native symlink reparse point) remotely ...?
> 
> On Sun, Sep 29, 2024 at 1:51 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > As SMB protocol distinguish between symlink to directory and symlink to
> > file, add some mechanism to disallow resolving incompatible types.
> >
> > When SMB symlink is of the directory type, ensure that its target path ends
> > with slash. This forces Linux to not allow resolving such symlink to file.
> >
> > And when SMB symlink is of the file type and its target path ends with
> > slash then returns an error as such symlink is unresolvable. Such symlink
> > always points to invalid location as file cannot end with slash.
> >
> > This mimics Windows behavior of native SMB symlinks.
> >
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/reparse.c   |  4 ++++
> >  fs/smb/client/smb2file.c  | 46 +++++++++++++++++++++++++++++++++++++++
> >  fs/smb/client/smb2inode.c |  4 ++++
> >  fs/smb/client/smb2proto.h |  1 +
> >  4 files changed, 55 insertions(+)
> >
> > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > index d8edb513556f..5a738f65b190 100644
> > --- a/fs/smb/client/reparse.c
> > +++ b/fs/smb/client/reparse.c
> > @@ -589,6 +589,10 @@ static int parse_reparse_symlink(struct reparse_symlink_data_buffer *sym,
> >                                        le32_to_cpu(sym->Flags) & SYMLINK_FLAG_RELATIVE,
> >                                        full_path,
> >                                        cifs_sb);
> > +       if (!rc) {
> > +               bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
> > +               rc = smb2_fix_symlink_target_type(&data->symlink_target, directory);
> > +       }
> >         return rc;
> >  }
> >
> > diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> > index dc52995f5591..8a1a1b2a1c81 100644
> > --- a/fs/smb/client/smb2file.c
> > +++ b/fs/smb/client/smb2file.c
> > @@ -63,6 +63,48 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
> >         return sym;
> >  }
> >
> > +int smb2_fix_symlink_target_type(char **target, bool directory)
> > +{
> > +       char *buf;
> > +       int len = strlen(*target);
> > +
> > +       if (!len)
> > +               return -EIO;
> > +
> > +       /*
> > +        * If this is directory symlink and it does not have trailing slash then
> > +        * append it. Trailing slash simulates Windows/SMB behavior which do not
> > +        * allow resolving directory symlink to file.
> > +        */
> > +       if (directory && (*target)[len-1] != '/') {
> > +               buf = kzalloc(len+2, GFP_KERNEL);
> > +               if (!buf)
> > +                       return -ENOMEM;
> > +               memcpy(buf, *target, len);
> > +               buf[len] = '/';
> > +               kfree(*target);
> > +               *target = buf;
> > +       }
> > +
> > +       /*
> > +        * If this is a symlink which points to file name with trailing slash,
> > +        * or to file named "." or file named ".." then this symlink cannot be
> > +        * resolved on Linux because Linux does not allow files with such names.
> > +        * So return an error to prevent resolving this file type symlink to
> > +        * directory, as it do not point to directory at all.
> > +        */
> > +       if (!directory) {
> > +               const char *basename = kbasename(*target);
> > +               int basename_len = strlen(basename);
> > +               if (basename_len == 0 || /* symname ends with slash */
> > +                   (basename_len == 1 && basename[0] == '.') || /* last component is "." */
> > +                   (basename_len == 2 && basename[0] == '.' && basename[1] == '.')) /* last component is ".." */
> > +                       return -EIO;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> >  int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec *iov,
> >                                 const char *full_path, char **path)
> >  {
> > @@ -132,6 +174,10 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
> >                                 rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data,
> >                                                NULL, NULL, NULL);
> >                                 oparms->create_options &= ~OPEN_REPARSE_POINT;
> > +                               if (!rc) {
> > +                                       bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
> > +                                       rc = smb2_fix_symlink_target_type(&data->symlink_target, directory);
> > +                               }
> >                         }
> >                 }
> >         }
> > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > index c9cdac7d2d50..faf0a8344faa 100644
> > --- a/fs/smb/client/smb2inode.c
> > +++ b/fs/smb/client/smb2inode.c
> > @@ -960,6 +960,10 @@ int smb2_query_path_info(const unsigned int xid,
> >                 rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
> >                                       &oparms, in_iov, cmds, num_cmds,
> >                                       cfile, NULL, NULL, NULL);
> > +               if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
> > +                       bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
> > +                       rc = smb2_fix_symlink_target_type(&data->symlink_target, directory);
> > +               }
> >                 break;
> >         case -EREMOTE:
> >                 break;
> > diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> > index 11cef65fa831..d308f3c2f8df 100644
> > --- a/fs/smb/client/smb2proto.h
> > +++ b/fs/smb/client/smb2proto.h
> > @@ -113,6 +113,7 @@ extern int smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
> >                           struct cifs_sb_info *cifs_sb,
> >                           const unsigned char *path, char *pbuf,
> >                           unsigned int *pbytes_read);
> > +int smb2_fix_symlink_target_type(char **target, bool directory);
> >  int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
> >                               bool unicode, bool relative,
> >                               const char *full_path,
> > --
> > 2.20.1
> >
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
