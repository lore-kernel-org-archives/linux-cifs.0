From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: Share mounts in SMBv1 mode, but fails to mount in SMBv2 mode
Date: Mon, 16 Oct 2017 16:51:30 +0200
Message-ID: <mpsa80ruowd.fsf@aaptelpc.suse.de>
References: <144390dd-e0fc-ae98-a645-5972f11d635d@lal.in2p3.fr> <mpsd15nv1up.fsf@aaptelpc.suse.de> <0b17f092-5c81-3b2e-5e48-b2a4c5b4145a@lal.in2p3.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Hadrien Grasland <grasland-dJj/bURytuEtnUBFBimtzg@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0b17f092-5c81-3b2e-5e48-b2a4c5b4145a-dJj/bURytuEtnUBFBimtzg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hadrien Grasland <grasland-dJj/bURytuEtnUBFBimtzg@public.gmane.org> writes:
>> If the server is a samba server, the /etc/samba/smb.conf would be
>> helpful.
>
> Output enclosed. Since a quick look suggests that all interesting 
> traffic is on port 445, I added a "port 445" rule to tcpdump in order to 
> reduce noise and keep unrelated local network traffic private, hope 
> that's fine.

When kerberos or DNS is involved it's always nice to see those too but
here I think it's fine with just SMB.

> I'm going to ask whether the server is samba-based or not, and if so 
> I'll try to have a look at the smb.conf file.

Great.

> [16491.702119] CIFS VFS: ioctl error in smb2_get_dfs_refer rc=-2

cifs.ko always does a DFS referal when mounting because some server
don't report DFS roots properly (Windows Server 2008, supposedly). Any
errors at this step are ignored so this is not the problem.

The actual issue is when we try to create the root inode of the fs. To
create a linux inode we need the file metadata from the SMB server. This
is done via a QUERY INFO requests which has a field to specify how much
metadata you need. cifs.ko always require the AllInfo level.

> [16491.704895] ../fs/cifs/inode.c: CIFS VFS: in cifs_root_iget as Xid: 2941 with uid: 0
> [16491.704897] ../fs/cifs/inode.c: Getting info on 
> [16491.704904] ../fs/cifs/smb2pdu.c: create/open
> [16491.705550] ../fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
> [16491.705553] ../fs/cifs/smb2misc.c: Calculated size 157 length 156 mismatch mid 14
> [16491.705593] ../fs/cifs/smb2pdu.c: Query Info
> [16491.706223] ../fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc00000bb to POSIX err -95
> [16491.706228] ../fs/cifs/smb2pdu.c: Close
> [16491.706861] ../fs/cifs/smb2pdu.c: create/open
> [16491.707476] ../fs/cifs/smb2misc.c: Calculated size 157 length 156 mismatch mid 17
> [16491.707514] ../fs/cifs/smb2pdu.c: Query Info
> [16491.708101] ../fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc00000bb to POSIX err -95
> [16491.708106] ../fs/cifs/smb2pdu.c: Close
> [16491.708752] CIFS VFS: cifs_read_super: get root inode failed

Call tree for this output is

cifs_read_super
  cifs_root_iget
    cifs_get_inode_info
      ops->query_path_info (smb2_query_path_info)


This function does the 2 query info requests:

>	rc = smb2_open_op_close(xid, tcon, cifs_sb, full_path,
>				FILE_READ_ATTRIBUTES, FILE_OPEN, 0,
>				smb2_data, SMB2_OP_QUERY_INFO);
>	if (rc == -EOPNOTSUPP) {
>		*symlink = true;
>		/* Failed on a symbolic link - query a reparse point info */
>		rc = smb2_open_op_close(xid, tcon, cifs_sb, full_path,
>					FILE_READ_ATTRIBUTES, FILE_OPEN,
>					OPEN_REPARSE_POINT, smb2_data,
>					SMB2_OP_QUERY_INFO);
>	}
>	if (rc)
>		goto out;

Looking at the trace the query info level used is FILE_ALL_INFORMATION
(0x12) and both fail with STATUS_NOT_SUPPORTED (frame #38,#39 and
#44,#45).

Regarding query info requests [MS-SMB2] 3.3.5.20.1 "Handling
SMB2_0_INFO_FILE" reads:

> Requests for information classes that are not listed in section 2.2.37
> but which are documented in section 2.4 of [MS-FSCC] SHOULD<351> be
> failed with STATUS_NOT_SUPPORTED.

AllInfo is listed in 2.2.37 so this is not it.

> The server MUST query the information requested from the underlying
> object store.<354> If the store does not support the data requested,
> the server MUST fail the request with STATUS_NOT_SUPPORTED.

This is the more likely explanation so far. This would mean "the
underlying filesystem on the server doesnt store all the fields the ALL
INFO level requires".

There was another query done by cifs.ko on the server FS info (frame #18
#19) which reported it as NTFS, which should support all the fields so
this doesn't make sense... Let's look at the wireshark trace more
closely.

Wireshark is a bit confused by some of the query info request fields:

>    GetInfo Request (0x10)
>        StructureSize: 0x0029
>            0000 0000 0010 100. = Fixed Part Length: 20
>            .... .... .... ...1 = Dynamic Part: True
>        Class: FILE_INFO (0x01)
>        InfoLevel: SMB2_FILE_ALL_INFO (0x12)
>        Max Response Size: 8293
>        unknown: 68000000000000000000000000000000
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ what's this?
>        GUID handle File: [unknown]
>            File Id: 002b8237-0000-0000-0500-000000000000
>            [Frame handle opened: 37]

The "[unknown]" part is ok, because we're querying the root of the
share, which is the empty filename ("").

Let's see what the unknown *field* corresponds to by reading the
specs. This could just be a wireshark issue as this code works against
other SMB servers just fine.

68 00        "InputBufferOffset"     (hmm.. see next)
00 00        "Reserved"              (specs says it must be zeros, ok)
00 00 00 00  "InputBufferLength"     (hmm.. actual buffer length is 1 but
                                      saying its zero in the packet
                                      might explain why it's working on
                                      others servers?)
00 00 00 00  "AdditionalInformation" (for security info queries, ok)
00 00 00 00  "Flags"                 (for EA info queries, ok)

> InputBufferOffset (2 bytes): The offset, in bytes, from the beginning
> of the SMB2 header to the input buffer. For quota requests, the input
> buffer MUST contain an SMB2_QUERY_QUOTA_INFO, as specified in section
> 2.2.37.1. For FileFullEaInformation requests, the input buffer MUST
> contain the user supplied EA list with zero or more
> FILE_GET_EA_INFORMATION structures, specified in [MS-FSCC] section
> 2.4.15.1. For other information queries, this field SHOULD<69> be set
> to 0.

InputBufferOffset is an offset from the start of the smb2 header so
that's 0x46 + 0x68 = 0xAE which points to the very last byte of the
packet, a NULL byte. This doesn't seem right. The specs clearly says the
offset must either be pointing to a proper {SMB2_QUERY_QUOTE_INFO,
FILE_GET_EA_INFO} struct or be null.

This also explains the length mismatch warning in the kernel console:

> [16491.707476] ../fs/cifs/smb2misc.c: Calculated size 157 length 156 mismatch mid 17

I'll try to write a patch for this so you can test it.

Cheers,

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
