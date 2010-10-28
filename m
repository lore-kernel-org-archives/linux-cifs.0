From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: remove "legacy" parm from CIFSSMBQPathInfo
Date: Thu, 28 Oct 2010 21:49:55 +0530
Message-ID: <4CC9A2AB.8090208@suse.de>
References: <4CC921E7.9020403@suse.de> <AANLkTikpemR3PVzXSimbu-b1zn4QwQj+0VAEM9xwgYqt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikpemR3PVzXSimbu-b1zn4QwQj+0VAEM9xwgYqt-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/28/2010 09:12 PM, Steve French wrote:
> What is the code flow then on Windows9x, OS/2 or in the EOPNOSUPP
> case?  Seems strange that we don't retry with legacy or in the case
> where the dialect (or previous call) shows that we don't support the
> infolevel.
> 

If CIFSSMBOpen fails, the callers seem to be fall back to legacy open using
SMBLegacyOpen().

cifs_open()

       ...
        if (tcon->ses->capabilities & CAP_NT_SMBS)
                rc = CIFSSMBOpen(xid, tcon, full_path, disposition,
                         desiredAccess, CREATE_NOT_DIR, &netfid, &oplock, buf,
                         cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
                                 & CIFS_MOUNT_MAP_SPECIAL_CHR);
        else
                rc = -EIO; /* no NT SMB support fall into legacy open below */
                
        if (rc == -EIO) {
                /* Old server, try legacy style OpenX */
                rc = SMBLegacyOpen(xid, tcon, full_path, disposition,
                        desiredAccess, CREATE_NOT_DIR, &netfid, &oplock, buf,
                        cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
                                & CIFS_MOUNT_MAP_SPECIAL_CHR);
        }



-- 
Suresh Jayaraman
