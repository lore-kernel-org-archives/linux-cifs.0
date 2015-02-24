From: Halvor Lund <halvor.lund-YlzW+7GAZUhhl2p70BpVqQ@public.gmane.org>
Subject: Access denied in sub-folder
Date: Tue, 24 Feb 2015 10:39:37 +0000 (UTC)
Message-ID: <loom.20150224T112226-189@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I'm having trouble accessing a folder of a share on a Windows Server 2008
R2. mount.cifs fails with "Permission denied", while smbclient succeeds,
when listing (ls) the folder contents.

In the path //server/share/folder I can access \\server\share using
mount.cifs, but not //server/share/folder.
By turning on debugging in /proc/fs/cifs/cifsFYI, I see the following status
codes in dmesg when trying to list //server/share/folder:
NT_STATUS_PATH_NOT_COVERED
NT_STATUS_MORE_PROCESSING_REQUIRED
NT_STATUS_NO_SUCH_DEVICE
NT_STATUS_ACCESS_DENIED

It seems that //server/share/folder is not a "true" path, but somehow
remapped to //anotherserver/anothershare/folder1/folder2, and that this has
something to do with the problem.

Kernel: 3.16.0-30-generic
mount.cifs version: 6.0

/proc/fs/cifs/DebugData:
2) Name: xxx.xxx.xxx.xxx  Domain: <domain> Uses: 1 OS: Windows Server 2008
R2 Enterprise 7601 Service Pack 1
	NOS: Windows Server 2008 R2 Enterprise 6.1	Capability: 0x1f3fc
	SMB session status: 1	TCP status: 1
	Local Users To Server: 1 SecMode: 0xf Req On Wire: 0
	Shares:
	1) \\server\share Mounts: 1 Type: NTFS DevInfo: 0x20 Attributes: 0xc700ff
	PathComponentMax: 255 Status: 0x1 type: DISK 

	MIDs:

Best regards,
Halvor Lund
