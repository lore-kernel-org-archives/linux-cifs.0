Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B421A0BC1;
	Mon, 30 Sep 2024 20:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727726433; cv=none; b=gWCMGBqmASZiLOkt+5yBXCWyArvlBtShy0hm7P36PFC4Lz0HkTO1OqWyqvXOKzaCJS1hf6srXPsMgTxp/paXSBrEY6cHisHQvD/LxZLH7yYtRLqALObnZetm8wpVVkSL0jrOuxivOthVPsZy9o09JtXO6KKdIsRkUTsu3A5mTB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727726433; c=relaxed/simple;
	bh=bQQl0J7oigVoPltFmsFgOAdJhsDIryixqNATTTe4sgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q/j9dik8C/pSB4rSu0zj8yqkRzGusM8jcH5+i/sCQ/DJC18+XWhwOykn2JP1+YqypphxEDyWK5P4lLuLVUbVE7/AlKzvTwVw9GrQZzkU5+KrWISZX5AOMcbuD+1Ka7GKieAcB0TjMekEHc1nESsmbAB/Qvn/YiqVJclztmIq5Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyrytrju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyrytrju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6564DC4CEC7;
	Mon, 30 Sep 2024 20:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727726432;
	bh=bQQl0J7oigVoPltFmsFgOAdJhsDIryixqNATTTe4sgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fyrytrjurUXkg0kB2CCROqN88/OD7D7pU5gJ6YoaTcpWq8HGGE3PP8f4ZUeRSzETP
	 5IlptH8RBe8raby+/4PvqNO7Ip9Zr+3bEf3eRdclq7BuO+1V/hg4g3yBlRGGs5Eayx
	 1j3MHcdeRBWOwax7eaga9+gGJ6hPUqFro6wEp4LGpPQg4B/gjLxncWhCNy0sAS25Ne
	 /PJnm7XnYw9X75Srxi05JZfk04KHDH1euHY/RO4w/zGtva/u6Ido1EczTtqXraCdMk
	 ijusM+JmADyjQ6wArY1Zqjj59Xd2HLdMsBfQUiQLmqmO8PPlHrM17yrfpfRWfRivX9
	 LIQjj+1vytLHQ==
Received: by pali.im (Postfix)
	id 2FB007D0; Mon, 30 Sep 2024 22:00:26 +0200 (CEST)
Date: Mon, 30 Sep 2024 22:00:26 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] cifs: Validate content of native symlink
Message-ID: <20240930200026.efjs2v6ssqridcqx@pali>
References: <20240929185053.10554-1-pali@kernel.org>
 <20240929185053.10554-7-pali@kernel.org>
 <CAH2r5mtRN04+X-J7C__qHL6S+VzFbWoRGdb=cBDQfDVLGgWwew@mail.gmail.com>
 <20240929221908.skkup4ds6ow2s77x@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hy7expdtsjuxndfn"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240929221908.skkup4ds6ow2s77x@pali>
User-Agent: NeoMutt/20180716


--hy7expdtsjuxndfn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Now I tested it. FSCTL_SET_REPARSE_POINT ioctl call on Windows accepts
also symlink path with zero characters. In attachment I'm sending simple
program which creates Windows relative symlink and accepts binary target
path via \xFF sequence. You can compile it with gcc/mingw option -municode.
So calling "set_reparse_symlink.exe symlink file\x00file" creates new
symlink which points to target path "file<nul>file".

On Monday 30 September 2024 00:19:08 Pali Rohár wrote:
> I think that via pike it could be possible or via windows application
> running locally (to create reparse point manually with prepared buffer
> with such content). I will check it later.
> 
> Just a side note: Windows NT kernel allows for object names any
> characters except backslash. For object names is not used nul-term
> string, but rather string with explicit length. So even a null character
> is a valid in a object name. NT NTFS driver has for file names more
> restrictions and null is not valid. But it does not mean that somebody
> can write own filesystem which allows null bytes in file names...
> And this design of explicit lengths is also in SMB, so NT kernel may
> export nul characters in symlink path buffers...
> 
> On Sunday 29 September 2024 16:48:46 Steve French wrote:
> > Is there any easy way to create such a symlink (with null in it)?
> > 
> > On Sun, Sep 29, 2024 at 1:51 PM Pali Rohár <pali@kernel.org> wrote:
> > >
> > > Check that buffer does not contain UTF-16 null codepoint
> > > because Linux cannot process symlink with null byte.
> > >
> > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > ---
> > >  fs/smb/client/reparse.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > >
> > > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > > index 5a738f65b190..ca4f96c43508 100644
> > > --- a/fs/smb/client/reparse.c
> > > +++ b/fs/smb/client/reparse.c
> > > @@ -509,6 +509,16 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
> > >         int rc;
> > >         int i;
> > >
> > > +       /*
> > > +        * Check that buffer does not contain UTF-16 null codepoint
> > > +        * because Linux cannot process symlink with null byte.
> > > +        */
> > > +       if (unicode && UniStrnlen((wchar_t *)buf, len/2) != len/2) {
> > > +               cifs_dbg(VFS, "srv returned null byte in native symlink target location\n");
> > > +               rc = -EIO;
> > > +               goto out;
> > > +       }
> > > +
> > >         smb_target = cifs_strndup_from_utf16(buf, len, unicode, cifs_sb->local_nls);
> > >         if (!smb_target) {
> > >                 rc = -ENOMEM;
> > > --
> > > 2.20.1
> > >
> > >
> > 
> > 
> > -- 
> > Thanks,
> > 
> > Steve

--hy7expdtsjuxndfn
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="set_reparse_symlink.c"

#include <stdio.h>
#include <windows.h>
#include <ntdef.h>

int wmain(int argc, wchar_t *argv[]) {
  static BYTE reparse_data_buffer[MAXIMUM_REPARSE_DATA_BUFFER_SIZE];
  REPARSE_DATA_BUFFER *reparse_buffer = (REPARSE_DATA_BUFFER *)reparse_data_buffer;
  DWORD reparse_buffer_length;
  TOKEN_PRIVILEGES privileges;
  DWORD target_length;
  wchar_t *target;
  HANDLE handle;
  HANDLE token;
  BOOL success;
  DWORD i;

  if (argc != 3) {
    printf("Usage: %ls new_file target\n", argv[0]);
    return 1;
  }

  target = argv[2];
  for (i = 0, target_length = 0; target[i]; i++, target_length++) {
    if (target[i] == L'\\') {
      if (target[i+1] == L'\\') {
        target[target_length] = L'\\';
        i++;
        continue;
      } else if (target[i+1] == L'x' && target[i+2] >= L'0' && target[i+2] <= L'9' && target[i+3] >= L'0' && target[i+3] <= L'9') {
        target[target_length] = ((target[i+2]-L'0') << 4) | (target[i+3]-L'0');
        i += 3;
        continue;
      }
    }
    target[target_length] = target[i];
  }
  target_length *= sizeof(target[0]);

  reparse_buffer_length = FIELD_OFFSET(REPARSE_DATA_BUFFER, SymbolicLinkReparseBuffer.PathBuffer) + target_length*2;
  if (reparse_buffer_length > MAXIMUM_REPARSE_DATA_BUFFER_SIZE) {
    printf("Target path is too long\n");
    return 1;
  }

  reparse_buffer->ReparseTag = IO_REPARSE_TAG_SYMLINK;
  reparse_buffer->ReparseDataLength = reparse_buffer_length - REPARSE_DATA_BUFFER_HEADER_SIZE;
  reparse_buffer->SymbolicLinkReparseBuffer.SubstituteNameOffset = 0;
  reparse_buffer->SymbolicLinkReparseBuffer.SubstituteNameLength = target_length;
  reparse_buffer->SymbolicLinkReparseBuffer.PrintNameOffset = target_length;
  reparse_buffer->SymbolicLinkReparseBuffer.PrintNameLength = target_length;
  reparse_buffer->SymbolicLinkReparseBuffer.Flags = SYMLINK_FLAG_RELATIVE;
  memcpy(reparse_buffer->SymbolicLinkReparseBuffer.PathBuffer, target, target_length);
  memcpy(((BYTE*)reparse_buffer->SymbolicLinkReparseBuffer.PathBuffer)+target_length, target, target_length);

  if (OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES, &token)) {
    if (LookupPrivilegeValue(NULL, SE_CREATE_SYMBOLIC_LINK_NAME, &privileges.Privileges[0].Luid)) {
      privileges.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
      privileges.PrivilegeCount = 1;
      AdjustTokenPrivileges(token, FALSE, &privileges, sizeof(privileges), NULL, NULL);
    }
    CloseHandle(token);
  }

  handle = CreateFileW(argv[1], FILE_WRITE_DATA, FILE_SHARE_VALID_FLAGS, NULL, OPEN_ALWAYS, FILE_FLAG_OPEN_REPARSE_POINT, NULL);
  if (handle == INVALID_HANDLE_VALUE && GetLastError() == ERROR_ACCESS_DENIED)
    handle = CreateFileW(argv[1], FILE_WRITE_DATA, FILE_SHARE_VALID_FLAGS, NULL, OPEN_ALWAYS, FILE_FLAG_OPEN_REPARSE_POINT | FILE_FLAG_BACKUP_SEMANTICS, NULL);
  if (handle == INVALID_HANDLE_VALUE) {
    printf("CreateFileW failed: %lu\n", GetLastError());
    return 1;
  }

  success = DeviceIoControl(handle, FSCTL_SET_REPARSE_POINT, reparse_buffer, reparse_buffer_length, NULL, 0, NULL, NULL);
  CloseHandle(handle);
  if (!success) {
    printf("FSCTL_SET_REPARSE_POINT failed: %lu\n", GetLastError());
    return 1;
  }

  return 0;
}

--hy7expdtsjuxndfn--
