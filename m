Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2E8157494;
	Mon, 14 Oct 2024 09:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728899542; cv=none; b=MP38NIKKeUJULQFQJ0Mu0V8dsmjNzDm1fUeYg4FFP81C5NWZewFHQquj5YWXl/r6zjVQL1jiAm/sMPDMOK1AEeY18OnOwFM9Ma1SsSTKQ1RX/Yyt+9wkeuXTKGUn6HSRgAi4GNbPKEIZcjxtvh1OwBewBS+x9uVyusa9GrMfGsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728899542; c=relaxed/simple;
	bh=7G2rTAKiIHvqKGEL3BERg1CQ7sWLWd/WC84/5LIrGJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h4tk17eoFZJ5xqE/dddS4+M8ADstxPDofWCcudBuaH64zOrg7sqriZfnijjkL+TzH1TB0bTARNsxbmtFqrfOqeT3t4prck7sxOXutcG5Foh2kqXK4HT7sge+0CUWjWyNHHneFgCMhFAba6rOTWulTUlBD8UQM6BttFp1a7u9I+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J2ds1tB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J2ds1tB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7085C4CEC3;
	Mon, 14 Oct 2024 09:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728899542;
	bh=7G2rTAKiIHvqKGEL3BERg1CQ7sWLWd/WC84/5LIrGJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J2ds1tB0p5clgZySms+JjjMYVGy5O4FdI8MqKAaZ+klDNiKsbSWvivx6TZVRsweDJ
	 U31CQXur1wqwAmU5Vvkb2GyLog35LayuPVnUB0EfddkLMpU8aMvU0S35BSobq/e8TJ
	 TQXL2efYj+C9T/p9iMsblNR/VortbDmDrQbcOahPAkhyDZqxfDRmthJBQTVjSDRgtd
	 v55indsD9kLWJCjXrimttt7x6dSAr3wwJvpaDL7o6/RwDuOsWblMGPKWJxGwL1uFE7
	 cRqhM1ZuJryFKisaP2qoDn5BlCKIe6diTAMyyAdM1dF0fQGOUK6UKjc9OPxg1xt6hW
	 dhNxBB9XrpFPQ==
Received: by pali.im (Postfix)
	id 981C29DA; Mon, 14 Oct 2024 11:52:15 +0200 (CEST)
Date: Mon, 14 Oct 2024 11:52:15 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] cifs: Fix parsing native symlinks directory/file
 type
Message-ID: <20241014095215.nae6hnwo23tk6yjs@pali>
References: <20240929185053.10554-1-pali@kernel.org>
 <20241005140300.19416-1-pali@kernel.org>
 <20241005140300.19416-5-pali@kernel.org>
 <CAH2r5mtbK7vRVHs6rosrvGuer52cyfdsyCt1FL3TFg4RXxULuA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mtbK7vRVHs6rosrvGuer52cyfdsyCt1FL3TFg4RXxULuA@mail.gmail.com>
User-Agent: NeoMutt/20180716

I see what you mean. The last check in smb2_fix_symlink_target_type
will disallow to use symlinks to "." and ".." created by older linux
client as it created it as symlink to file, instead of symlink to dir.

This is a good point. I can send a new version with dropped last check
in smb2_fix_symlink_target_type.

On Sunday 13 October 2024 12:56:23 Steve French wrote:
> Would this break any pure Linux client example, mounted to Windows,
> where previously the Linux client created all symlinks as file
> symlinks?  e.g. If there were two Linux clients writing to the share,
> one that included this fix and one that did not.
> 
> On Sat, Oct 5, 2024 at 9:03 AM Pali Rohár <pali@kernel.org> wrote:
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
> > As POSIX server does not distinguish between symlinks to file and symlink
> > directory, do not apply this change for symlinks from POSIX SMB server. For
> > POSIX SMB servers, this change does nothing.
> >
> > This mimics Windows behavior of native SMB symlinks.
> >
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/inode.c     |  5 ++++
> >  fs/smb/client/smb2file.c  | 55 +++++++++++++++++++++++++++++++++++++++
> >  fs/smb/client/smb2inode.c |  4 +++
> >  fs/smb/client/smb2proto.h |  1 +
> >  4 files changed, 65 insertions(+)
> >
> > diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> > index 0fe54b2d2561..aa38a3935f8f 100644
> > --- a/fs/smb/client/inode.c
> > +++ b/fs/smb/client/inode.c
> > @@ -1110,6 +1110,11 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
> >                                                               full_path,
> >                                                               iov, data);
> >                 }
> > +
> > +               if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
> > +                       bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
> > +                       rc = smb2_fix_symlink_target_type(&data->symlink_target, directory, cifs_sb);
> > +               }
> >                 break;
> >         }
> >
> > diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> > index dc52995f5591..149449d9c1c0 100644
> > --- a/fs/smb/client/smb2file.c
> > +++ b/fs/smb/client/smb2file.c
> > @@ -63,6 +63,56 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
> >         return sym;
> >  }
> >
> > +int smb2_fix_symlink_target_type(char **target, bool directory, struct cifs_sb_info *cifs_sb)
> > +{
> > +       char *buf;
> > +       int len;
> > +
> > +       /*
> > +        * POSIX server does not distinguish between symlinks to file and
> > +        * symlink directory. So nothing is needed to fix on the client side.
> > +        */
> > +       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
> > +               return 0;
> > +
> > +       len = strlen(*target);
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
> > +                   (basename_len == 2 && basename[0] == '.' && basename[1] == '.')) /* or ".." */
> > +                       return -EIO;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> >  int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec *iov,
> >                                 const char *full_path, char **path)
> >  {
> > @@ -133,6 +183,11 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
> >                                                NULL, NULL, NULL);
> >                                 oparms->create_options &= ~OPEN_REPARSE_POINT;
> >                         }
> > +                       if (!rc) {
> > +                               bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
> > +                               rc = smb2_fix_symlink_target_type(&data->symlink_target,
> > +                                                                 directory, oparms->cifs_sb);
> > +                       }
> >                 }
> >         }
> >
> > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > index 9a28a30ec1a3..06bb6f7fbf0f 100644
> > --- a/fs/smb/client/smb2inode.c
> > +++ b/fs/smb/client/smb2inode.c
> > @@ -960,6 +960,10 @@ int smb2_query_path_info(const unsigned int xid,
> >                 rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
> >                                       &oparms, in_iov, cmds, num_cmds,
> >                                       cfile, NULL, NULL, NULL);
> > +               if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
> > +                       bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
> > +                       rc = smb2_fix_symlink_target_type(&data->symlink_target, directory, cifs_sb);
> > +               }
> >                 break;
> >         case -EREMOTE:
> >                 break;
> > diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> > index aa01ae234732..1828b825c7d3 100644
> > --- a/fs/smb/client/smb2proto.h
> > +++ b/fs/smb/client/smb2proto.h
> > @@ -113,6 +113,7 @@ extern int smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
> >                           struct cifs_sb_info *cifs_sb,
> >                           const unsigned char *path, char *pbuf,
> >                           unsigned int *pbytes_read);
> > +int smb2_fix_symlink_target_type(char **target, bool directory, struct cifs_sb_info *cifs_sb);
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
