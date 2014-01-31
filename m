From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS VFS: Send error in Flush = -9
Date: Fri, 31 Jan 2014 14:07:57 -0600
Message-ID: <CADT32e+5whrPysC+8JmNupP1WPS1dT6hbb8O+DrH=SYSpsLk4w@mail.gmail.com>
References: <loom.20140131T193830-201@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20140131T193830-201-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

-9 is EBADF.

If you can send a wireshark trace of traffic between client and server
that would be helpful.



On Fri, Jan 31, 2014 at 1:20 PM, Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
> Hi there,
>
> I'm getting lots of CIFS errors in my system log:
>
> Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS VFS: Send error
>  in Flush = -9
> Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS VFS: Send error
>  in Flush = -9
> Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS VFS: Send error
>  in Flush = -9
>
> Usually 10-20 messages will appear at once like this.  This had happened
> occasionally when I was on Ubuntu 12.04 LTS, but since upgrading to
> Ubuntu 13.10 they are appearing daily (I actually upgraded to get a
> newer version of cifs-utils in the hopes that the problem would go away).
>
> Modinfo cifs shows cifs.ko at version 2.01, and cifs-utils is at 6.0.
>
> The share is mounted via fstab:
> //server2/share /media/tm cifs credentials=/home/jeff/.smbcredentials,
> _netdev,uid=jeff,gid=jeff,file_mode=0777,dir_mode=0777,iocharset=utf8
> ,sec=ntlm 0 0
>
> I increased logging to level "3" and here is what's going on when the first
> Flush error occurs (sorry about the formatting, Gmane is limiting each
> line to 80 chars):
>
> Jan 31 06:17:36 Server1 kernel: [70838.026873] /build/buildd/linux-3.11.0/
> fs/cifs/connect.c: RFC1002 header 0x23
> Jan 31 06:17:36 Server1 kernel: [70838.026879] /build/buildd/linux-3.11.0/
> fs/cifs/misc.c: checkSMB Length: 0x27, smb_buf_length: 0x23
> Jan 31 06:17:36 Server1 kernel: [70838.026889] /build/buildd/linux-3.11.0/
> fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=34092 state=4
> Jan 31 06:17:36 Server1 kernel: [70838.026893] /build/buildd/linux-3.11.0/
> fs/cifs/file.c: CIFS VFS: leaving cifs_strict_fsync (xid = 2694478) rc = 0
> Jan 31 06:17:36 Server1 kernel: [70838.027602] /build/buildd/linux-3.11.0/
> fs/cifs/file.c: CIFS VFS: in cifs_strict_fsync as Xid: 2694479 with uid: 1000
> Jan 31 06:17:36 Server1 kernel: [70838.027606] /build/buildd/linux-3.11.0/
> fs/cifs/file.c: Sync file - name: 1c datasync: 0x0
> Jan 31 06:17:36 Server1 kernel: [70838.027610] /build/buildd/linux-3.11.0/
> fs/cifs/cifssmb.c: In CIFSSMBFlush
> Jan 31 06:17:36 Server1 kernel: [70838.027614] /build/buildd/linux-3.11.0/
> fs/cifs/transport.c: For smb_command 5
> Jan 31 06:17:36 Server1 kernel: [70838.027618] /build/buildd/linux-3.11.0/
> fs/cifs/transport.c: Sending smb: smb_len=37
> Jan 31 06:17:36 Server1 kernel: [70838.027875] /build/buildd/linux-3.11.0/
> fs/cifs/connect.c: RFC1002 header 0x23
> Jan 31 06:17:36 Server1 kernel: [70838.027882] /build/buildd/linux-3.11.0/
> fs/cifs/misc.c: checkSMB Length: 0x27, smb_buf_length: 0x23
> Jan 31 06:17:36 Server1 kernel: [70838.027896] /build/buildd/linux-3.11.0/
> fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=34093 state=4
> Jan 31 06:17:36 Server1 kernel: [70838.027900] Status code returned 0xc0000008
> NT_STATUS_INVALID_HANDLE
> Jan 31 06:17:36 Server1 kernel: [70838.027906] /build/buildd/linux-3.11.0/
> fs/cifs/netmisc.c: Mapping smb error code 0xc0000008 to POSIX err -9
> Jan 31 06:17:36 Server1 kernel: [70838.027910] CIFS VFS: Send error in Flush = -9
> Jan 31 06:17:36 Server1 kernel: [70838.027915] /build/buildd/linux-3.11.0/
> fs/cifs/file.c: CIFS VFS: leaving cifs_strict_fsync (xid = 2694479) rc = -9
> Jan 31 06:17:36 Server1 kernel: [70838.027981] /build/buildd/linux-3.11.0/
> fs/cifs/xattr.c: CIFS VFS: in cifs_getxattr as Xid: 2694480 with uid: 1000
> Jan 31 06:17:36 Server1 kernel: [70838.027985] /build/buildd/linux-3.11.0/
> fs/cifs/dir.c: name: \afpd.log
> Jan 31 06:17:36 Server1 kernel: [70838.027989] /build/buildd/linux-3.11.0/
> fs/cifs/xattr.c: Security xattr namespace not supported yet
> Jan 31 06:17:36 Server1 kernel: [70838.027992] /build/buildd/linux-3.11.0/
> fs/cifs/xattr.c: CIFS VFS: leaving cifs_getxattr (xid = 2694480) rc = -95
>
> Any suggestions of how to work around this or how I could provide more info?
>
>
> Thanks!
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
