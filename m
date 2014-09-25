From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: How mode bits are stored in NFS/NTFS/CIFS/SMB3 ACLs
Date: Thu, 25 Sep 2014 01:04:37 -0500
Message-ID: <CAH2r5mt70hDes3tHMuij3YkDY9N2aG+bL77mhkg7k2W1y6W-jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Did some experiments today to see how mode bits are stored by the
Windows NFS server in the RichACL (CIFS or NFS ACL).   mounted nfsv4.1
to Windows from Linux then created a bunch of files and did chmod of
various combinations of 07777 bits (including sticky, setuid etc.)

Windows NFS server is storing the user owner bits with SID
S-1-5-88-1 and using SID S-15-88-2 for group owner and S-1-5-88-4 for
the ACE for "other" (this is easy to spot over CIFS/SMB3 etc because
user owner and group owner map to these SIDs in the security
descriptor returned over the wire).

As expected, for each of the 3 ACEs, it is setting "GENERIC_READ" in
the ACE for '4' (read) and GENERIC_WRITE for '2' (write) and
GENERIC_EXECUTE for '1' (execute).  What is puzzling is where it
stores the setuid and sticky bits (bits 07000) because they are not
visible in the CIFS/NTFS ACL.

Interesting that Windows's ACL management tool "cacls" doesn't display
the human readable names of the three special SIDs (even when run
locally on NTFS) although does display the ACE associated with the sid
with its raw SID.

Trying it on a different server which also handles both NFS and
CIFS/SMB3, the Mac, was also interesting.
Strangely enough the Mac client didn't seem to recognize these ACEs (I
thought they did) - and ls -l in Mac's bash always shows mode of 0700

In addition the Mac server doesn't seem to support Query Security
descriptor from cifs (Linux) or SMB2.1 (Windows 8.1) so I couldn't run
"cacls" on the Windows mount to Mac server to view how the Mac handles
chmod of the various permission bits (what it does to emulate them in
the ACL).



-- 
Thanks,

Steve
