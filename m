From: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: Re: How mode bits are stored in NFS/NTFS/CIFS/SMB3 ACLs
Date: Thu, 25 Sep 2014 11:29:51 +0100
Message-ID: <5154DE0E-C6D9-4051-AE5C-3AC38FB1B7BA@cam.ac.uk>
References: <CAH2r5mt70hDes3tHMuij3YkDY9N2aG+bL77mhkg7k2W1y6W-jQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt70hDes3tHMuij3YkDY9N2aG+bL77mhkg7k2W1y6W-jQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

On 25 Sep 2014, at 07:04, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Did some experiments today to see how mode bits are stored by the
> Windows NFS server in the RichACL (CIFS or NFS ACL).   mounted nfsv4.1
> to Windows from Linux then created a bunch of files and did chmod of
> various combinations of 07777 bits (including sticky, setuid etc.)
> 
> Windows NFS server is storing the user owner bits with SID
> S-1-5-88-1 and using SID S-15-88-2 for group owner and S-1-5-88-4 for
> the ACE for "other" (this is easy to spot over CIFS/SMB3 etc because
> user owner and group owner map to these SIDs in the security
> descriptor returned over the wire).
> 
> As expected, for each of the 3 ACEs, it is setting "GENERIC_READ" in
> the ACE for '4' (read) and GENERIC_WRITE for '2' (write) and
> GENERIC_EXECUTE for '1' (execute).  What is puzzling is where it
> stores the setuid and sticky bits (bits 07000) because they are not
> visible in the CIFS/NTFS ACL.

As far as I know the Windows NFS server user "Services For Unix (SFU)" and those special bits are stored on NTFS in an Extended Attribute (EA) (note this is the $EA attribute not a named stream/named $DATA attribute on NTFS).  I wrote about this 9 years ago on linux-ntfs-dev mailing list.  Archive post is here (read my point "2" in that post for the details):

	http://marc.info/?l=linux-ntfs-dev&m=112965244715312

This means that those bits only take effect / have any significance for applications using the Windows POSIX subsystem (e.g. NFS server and Cygwin), i.e. normal Win32 based apps will not be affected by them at all.

Best regards,

	Anton

> Interesting that Windows's ACL management tool "cacls" doesn't display
> the human readable names of the three special SIDs (even when run
> locally on NTFS) although does display the ACE associated with the sid
> with its raw SID.
> 
> Trying it on a different server which also handles both NFS and
> CIFS/SMB3, the Mac, was also interesting.
> Strangely enough the Mac client didn't seem to recognize these ACEs (I
> thought they did) - and ls -l in Mac's bash always shows mode of 0700
> 
> In addition the Mac server doesn't seem to support Query Security
> descriptor from cifs (Linux) or SMB2.1 (Windows 8.1) so I couldn't run
> "cacls" on the Windows mount to Mac server to view how the Mac handles
> chmod of the various permission bits (what it does to emulate them in
> the ACL).

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK
