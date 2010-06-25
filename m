From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 05/10] cifs: define superblock-level cache index objects and register them
Date: Fri, 25 Jun 2010 14:26:52 +0100
Message-ID: <23204.1277472412@redhat.com>
References: <22746.1277470713@redhat.com> <4C24A4A0.90408@suse.de> <1277220206-3559-1-git-send-email-sjayaraman@suse.de> <yes> <9720.1277312290@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <22746.1277470713-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> > > validate the root directory of the share in some way?
> >
> > I don't know if there is a way to do this.
> 
> Is there an inode number or something?  Even the creation time might do.

Looking in cifspdu.h, there are a number of things that it might be possible
to use.

 (1) FILE_ALL_INFO: CreationTime, IndexNumber, IndexNumber1, FileName
     (assuming this isn't flattened to '\' or something for the root of a
     share.

 (2) FILE_UNIX_BASIC_INFO: DevMajor, DevMinor, UniqueId.

 (3) FILE_INFO_STANDARD: CreationDate, CreationTime.

 (4) FILE_INFO_BASIC: CreationTime.

 (5) FILE_DIRECTORY_INFO: FileIndex, CreationTime, FileName.

 (6) SEARCH_ID_FULL_DIR_INFO: FileIndex, CreationTime, UniqueId, FileName.

 (7) FILE_BOTH_DIRECTORY_INFO: FileIndex, CreationTime, ShortName, FileName.

 (8) OPEN_RSP_EXT: Fid, CreationTime, VolumeGUID, FileId.

You may have to choose different sets of things, depending on what the server
has on offer.  Also, don't forget, if you can't work out whether a share is
coherent or not from the above, you can always use LastWriteTime, ChangeTime
and EndOfFile and just discard the whole subtree if they differ.

David
