Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC6D2EC55C;
	Fri, 31 Oct 2025 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761904233; cv=none; b=u4ZDHpacIyRgra8UW8abbSYMV44CVtA+7Q1lNGrNZnmecboEqb6s8rmj8q4CMSVdsgtT5rG7+XSno/+85pgZIz14PTbof0cyIUnEJ76qenTp+D43vasLuCUiQyMN5bsK5ae24kqcEoezvadCdpSH7CvBSh8ybY/A3pWkYndpkIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761904233; c=relaxed/simple;
	bh=AAQzpALIEI1byftEsiLhQiQHITLlo7WCtAEx+og5c90=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MMFtTJqzkTyWRI9eawNNGbjBXVbyVt0hoU06uYhsYAebKGxFFqDGVFtKk7BaJOkMtA5M0iKjOh7vQJwU1HanhgTQeSO+piwsnbweQeHqMrdrPHfPSjfPWJKsct/Ypk2dfLPiMIynWYuuFlgGNFh8bB1cLZ1DLMOzUM2OwKW09JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 0334b378b63f11f0a38c85956e01ac42-20251031
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:fd5c9343-223a-4aa9-8dd0-8b82aa9f7579,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:08725b749243088ea88a5cfc84936d74,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:99|80|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0334b378b63f11f0a38c85956e01ac42-20251031
X-User: chenxiaosong@kylinos.cn
Received: from [10.42.20.206] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <chenxiaosong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 388334684; Fri, 31 Oct 2025 17:50:20 +0800
Message-ID: <c2895654-82a8-4548-80af-b3f3d9936dd3@kylinos.cn>
Date: Fri, 31 Oct 2025 17:50:17 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/24] smb: move some duplicate definitions to
 common/smb1pdu.h
To: chenxiaosong.chenxiaosong@linux.dev, sfrench@samba.org,
 smfrench@gmail.com, linkinjeon@kernel.org, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr, =?UTF-8?Q?Ralph_B=C3=B6hme?= <slow@samba.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251027071316.3468472-6-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@kylinos.cn>
In-Reply-To: <20251027071316.3468472-6-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greetings,

I couldn't find the definition of ATTR_VOLUME and ATTR_DEVICE in any of 
the following documents:

   - MS-FSCC: 
https://learn.microsoft.com/pdf?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-fscc%2Ftoc.json
   - MS-CIFS: 
https://learn.microsoft.com/pdf?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-cifs%2Ftoc.json
   - MS-SMB: 
https://learn.microsoft.com/pdf?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-smb%2Ftoc.json
   - MS-SMB2: 
https://learn.microsoft.com/pdf?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-smb2%2Ftoc.json
   - smb3-posix-spec: https://gitlab.com/samba-team/smb3-posix-spec

Are these two macro definitions (ATTR_VOLUME and ATTR_DEVICE) defined in 
other documents?

PS: The following are the document locations I found for the File 
Attribute flags:

/*
  * File Attribute flags
  */
#define ATTR_READONLY   0x0001  /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_HIDDEN     0x0002  /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_SYSTEM     0x0004  /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_VOLUME     0x0008	/* ? */
#define ATTR_DIRECTORY  0x0010  /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_ARCHIVE    0x0020  /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_DEVICE     0x0040	/* ? */
#define ATTR_NORMAL     0x0080  /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_TEMPORARY  0x0100  /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_SPARSE     0x0200  /* See MS-SMB 2.2.1.2.1 */
#define ATTR_REPARSE    0x0400  /* See MS-SMB 2.2.1.2.1 */
#define ATTR_COMPRESSED 0x0800  /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_OFFLINE    0x1000  /* See MS-SMB 2.2.1.2.1
                                    ie file not immediately available -
                                    on offline storage */
#define ATTR_NOT_CONTENT_INDEXED 0x2000         /* See MS-SMB 2.2.1.2.1 */
#define ATTR_ENCRYPTED          0x4000          /* See MS-SMB 2.2.1.2.1 */
#define ATTR_POSIX_SEMANTICS    0x01000000      /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_BACKUP_SEMANTICS   0x02000000      /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_DELETE_ON_CLOSE    0x04000000      /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_SEQUENTIAL_SCAN    0x08000000      /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_RANDOM_ACCESS      0x10000000      /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_NO_BUFFERING       0x20000000      /* See MS-CIFS 2.2.1.2.3 */
#define ATTR_WRITE_THROUGH      0x80000000      /* See MS-CIFS 2.2.1.2.3 */

Thanks,
ChenXiaoSong.

On 10/27/25 15:12, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> In order to maintain the code more easily, move duplicate definitions to
> new common header file.
> 
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/smb/client/cifspdu.h    | 152 +---------------------------------
>   fs/smb/common/smb1pdu.h    | 163 +++++++++++++++++++++++++++++++++++++
>   fs/smb/server/smb_common.h |  79 +-----------------
>   3 files changed, 165 insertions(+), 229 deletions(-)
>   create mode 100644 fs/smb/common/smb1pdu.h
> 
> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> index d9cf7db0ac35..86167875574c 100644
> --- a/fs/smb/client/cifspdu.h
> +++ b/fs/smb/client/cifspdu.h
> @@ -12,44 +12,12 @@
>   #include <net/sock.h>
>   #include <linux/unaligned.h>
>   #include "../common/smbfsctl.h"
> +#include "../common/smb1pdu.h"
>   
>   #define CIFS_PROT   0
>   #define POSIX_PROT  (CIFS_PROT+1)
>   #define BAD_PROT 0xFFFF
>   
> -/* SMB command codes:
> - * Note some commands have minimal (wct=0,bcc=0), or uninteresting, responses
> - * (ie which include no useful data other than the SMB error code itself).
> - * This can allow us to avoid response buffer allocations and copy in some cases
> - */
> -#define SMB_COM_CREATE_DIRECTORY      0x00 /* trivial response */
> -#define SMB_COM_DELETE_DIRECTORY      0x01 /* trivial response */
> -#define SMB_COM_CLOSE                 0x04 /* triv req/rsp, timestamp ignored */
> -#define SMB_COM_FLUSH                 0x05 /* triv req/rsp */
> -#define SMB_COM_DELETE                0x06 /* trivial response */
> -#define SMB_COM_RENAME                0x07 /* trivial response */
> -#define SMB_COM_QUERY_INFORMATION     0x08 /* aka getattr */
> -#define SMB_COM_SETATTR               0x09 /* trivial response */
> -#define SMB_COM_LOCKING_ANDX          0x24 /* trivial response */
> -#define SMB_COM_COPY                  0x29 /* trivial rsp, fail filename ignrd*/
> -#define SMB_COM_ECHO                  0x2B /* echo request */
> -#define SMB_COM_OPEN_ANDX             0x2D /* Legacy open for old servers */
> -#define SMB_COM_READ_ANDX             0x2E
> -#define SMB_COM_WRITE_ANDX            0x2F
> -#define SMB_COM_TRANSACTION2          0x32
> -#define SMB_COM_TRANSACTION2_SECONDARY 0x33
> -#define SMB_COM_FIND_CLOSE2           0x34 /* trivial response */
> -#define SMB_COM_TREE_DISCONNECT       0x71 /* trivial response */
> -#define SMB_COM_NEGOTIATE             0x72
> -#define SMB_COM_SESSION_SETUP_ANDX    0x73
> -#define SMB_COM_LOGOFF_ANDX           0x74 /* trivial response */
> -#define SMB_COM_TREE_CONNECT_ANDX     0x75
> -#define SMB_COM_NT_TRANSACT           0xA0
> -#define SMB_COM_NT_TRANSACT_SECONDARY 0xA1
> -#define SMB_COM_NT_CREATE_ANDX        0xA2
> -#define SMB_COM_NT_CANCEL             0xA4 /* no response */
> -#define SMB_COM_NT_RENAME             0xA5 /* trivial response */
> -
>   /* Transact2 subcommand codes */
>   #define TRANS2_OPEN                   0x00
>   #define TRANS2_FIND_FIRST             0x01
> @@ -86,7 +54,6 @@
>   #define NT_TRANSACT_GET_USER_QUOTA    0x07
>   #define NT_TRANSACT_SET_USER_QUOTA    0x08
>   
> -#define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
>   /* future chained NTCreateXReadX bigger, but for time being NTCreateX biggest */
>   /* among the requests (NTCreateX response is bigger with wct of 34) */
>   #define MAX_CIFS_HDR_SIZE 0x58 /* 4 len + 32 hdr + (2*24 wct) + 2 bct + 2 pad */
> @@ -150,36 +117,6 @@
>   #define SMBOPEN_OTRUNC        0x0002
>   #define SMBOPEN_OAPPEND       0x0001
>   
> -/*
> - * SMB flag definitions
> - */
> -#define SMBFLG_EXTD_LOCK 0x01	/* server supports lock-read write-unlock smb */
> -#define SMBFLG_RCV_POSTED 0x02	/* obsolete */
> -#define SMBFLG_RSVD 0x04
> -#define SMBFLG_CASELESS 0x08	/* all pathnames treated as caseless (off
> -				implies case sensitive file handling request) */
> -#define SMBFLG_CANONICAL_PATH_FORMAT 0x10	/* obsolete */
> -#define SMBFLG_OLD_OPLOCK 0x20	/* obsolete */
> -#define SMBFLG_OLD_OPLOCK_NOTIFY 0x40	/* obsolete */
> -#define SMBFLG_RESPONSE 0x80	/* this PDU is a response from server */
> -
> -/*
> - * SMB flag2 definitions
> - */
> -#define SMBFLG2_KNOWS_LONG_NAMES cpu_to_le16(1)	/* can send long (non-8.3)
> -						   path names in response */
> -#define SMBFLG2_KNOWS_EAS cpu_to_le16(2)
> -#define SMBFLG2_SECURITY_SIGNATURE cpu_to_le16(4)
> -#define SMBFLG2_COMPRESSED (8)
> -#define SMBFLG2_SECURITY_SIGNATURE_REQUIRED (0x10)
> -#define SMBFLG2_IS_LONG_NAME cpu_to_le16(0x40)
> -#define SMBFLG2_REPARSE_PATH (0x400)
> -#define SMBFLG2_EXT_SEC cpu_to_le16(0x800)
> -#define SMBFLG2_DFS cpu_to_le16(0x1000)
> -#define SMBFLG2_PAGING_IO cpu_to_le16(0x2000)
> -#define SMBFLG2_ERR_STATUS cpu_to_le16(0x4000)
> -#define SMBFLG2_UNICODE cpu_to_le16(0x8000)
> -
>   /*
>    * These are the file access permission bits defined in CIFS for the
>    * NTCreateAndX as well as the level 0x107
> @@ -292,7 +229,6 @@
>   #define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
>   				| READ_CONTROL | SYNCHRONIZE)
>   
> -
>   /*
>    * Invalid readdir handle
>    */
> @@ -322,33 +258,6 @@
>   #define CIFS_ALIAS_TYPE_FILE 0x0001
>   #define CIFS_SHARE_TYPE_FILE 0x0000
>   
> -/*
> - * File Attribute flags
> - */
> -#define ATTR_READONLY  0x0001
> -#define ATTR_HIDDEN    0x0002
> -#define ATTR_SYSTEM    0x0004
> -#define ATTR_VOLUME    0x0008
> -#define ATTR_DIRECTORY 0x0010
> -#define ATTR_ARCHIVE   0x0020
> -#define ATTR_DEVICE    0x0040
> -#define ATTR_NORMAL    0x0080
> -#define ATTR_TEMPORARY 0x0100
> -#define ATTR_SPARSE    0x0200
> -#define ATTR_REPARSE   0x0400
> -#define ATTR_COMPRESSED 0x0800
> -#define ATTR_OFFLINE    0x1000	/* ie file not immediately available -
> -					on offline storage */
> -#define ATTR_NOT_CONTENT_INDEXED 0x2000
> -#define ATTR_ENCRYPTED  0x4000
> -#define ATTR_POSIX_SEMANTICS 0x01000000
> -#define ATTR_BACKUP_SEMANTICS 0x02000000
> -#define ATTR_DELETE_ON_CLOSE 0x04000000
> -#define ATTR_SEQUENTIAL_SCAN 0x08000000
> -#define ATTR_RANDOM_ACCESS   0x10000000
> -#define ATTR_NO_BUFFERING    0x20000000
> -#define ATTR_WRITE_THROUGH   0x80000000
> -
>   /* ShareAccess flags */
>   #define FILE_NO_SHARE     0x00000000
>   #define FILE_SHARE_READ   0x00000001
> @@ -417,38 +326,6 @@
>   #define GETU16(var)  (*((__u16 *)var))	/* BB check for endian issues */
>   #define GETU32(var)  (*((__u32 *)var))	/* BB check for endian issues */
>   
> -struct smb_hdr {
> -	__be32 smb_buf_length;	/* BB length is only two (rarely three) bytes,
> -		with one or two byte "type" preceding it that will be
> -		zero - we could mask the type byte off */
> -	__u8 Protocol[4];
> -	__u8 Command;
> -	union {
> -		struct {
> -			__u8 ErrorClass;
> -			__u8 Reserved;
> -			__le16 Error;
> -		} __attribute__((packed)) DosError;
> -		__le32 CifsError;
> -	} __attribute__((packed)) Status;
> -	__u8 Flags;
> -	__le16 Flags2;		/* note: le */
> -	__le16 PidHigh;
> -	union {
> -		struct {
> -			__le32 SequenceNumber;  /* le */
> -			__u32 Reserved; /* zero */
> -		} __attribute__((packed)) Sequence;
> -		__u8 SecuritySignature[8];	/* le */
> -	} __attribute__((packed)) Signature;
> -	__u8 pad[2];
> -	__u16 Tid;
> -	__le16 Pid;
> -	__u16 Uid;
> -	__le16 Mid;
> -	__u8 WordCount;
> -} __attribute__((packed));
> -
>   /* given a pointer to an smb_hdr, retrieve a void pointer to the ByteCount */
>   static inline void *
>   BCC(struct smb_hdr *smb)
> @@ -2239,33 +2116,6 @@ typedef struct {
>   /* minimum includes first three fields, and empty FS Name */
>   #define MIN_FS_ATTR_INFO_SIZE 12
>   
> -
> -/* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
> -#define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
> -#define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
> -#define FILE_SUPPORT_INTEGRITY_STREAMS	0x04000000
> -#define FILE_SUPPORTS_USN_JOURNAL	0x02000000
> -#define FILE_SUPPORTS_OPEN_BY_FILE_ID	0x01000000
> -#define FILE_SUPPORTS_EXTENDED_ATTRIBUTES 0x00800000
> -#define FILE_SUPPORTS_HARD_LINKS	0x00400000
> -#define FILE_SUPPORTS_TRANSACTIONS	0x00200000
> -#define FILE_SEQUENTIAL_WRITE_ONCE	0x00100000
> -#define FILE_READ_ONLY_VOLUME		0x00080000
> -#define FILE_NAMED_STREAMS		0x00040000
> -#define FILE_SUPPORTS_ENCRYPTION	0x00020000
> -#define FILE_SUPPORTS_OBJECT_IDS	0x00010000
> -#define FILE_VOLUME_IS_COMPRESSED	0x00008000
> -#define FILE_SUPPORTS_POSIX_UNLINK_RENAME 0x00000400
> -#define FILE_RETURNS_CLEANUP_RESULT_INFO  0x00000200
> -#define FILE_SUPPORTS_REMOTE_STORAGE	0x00000100
> -#define FILE_SUPPORTS_REPARSE_POINTS	0x00000080
> -#define FILE_SUPPORTS_SPARSE_FILES	0x00000040
> -#define FILE_VOLUME_QUOTAS		0x00000020
> -#define FILE_FILE_COMPRESSION		0x00000010
> -#define FILE_PERSISTENT_ACLS		0x00000008
> -#define FILE_UNICODE_ON_DISK		0x00000004
> -#define FILE_CASE_PRESERVED_NAMES	0x00000002
> -#define FILE_CASE_SENSITIVE_SEARCH	0x00000001
>   typedef struct {
>   	__le32 Attributes;
>   	__le32 MaxPathNameComponentLength;
> diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
> new file mode 100644
> index 000000000000..f14d3d9aac22
> --- /dev/null
> +++ b/fs/smb/common/smb1pdu.h
> @@ -0,0 +1,163 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +/*
> + *
> + *   Copyright (c) International Business Machines  Corp., 2002,2009
> + *   Author(s): Steve French (sfrench@us.ibm.com)
> + *
> + */
> +
> +#ifndef _COMMON_SMB1_PDU_H
> +#define _COMMON_SMB1_PDU_H
> +
> +/* SMB command codes:
> + * Note some commands have minimal (wct=0,bcc=0), or uninteresting, responses
> + * (ie which include no useful data other than the SMB error code itself).
> + * This can allow us to avoid response buffer allocations and copy in some cases
> + */
> +#define SMB_COM_CREATE_DIRECTORY      0x00 /* trivial response */
> +#define SMB_COM_DELETE_DIRECTORY      0x01 /* trivial response */
> +#define SMB_COM_CLOSE                 0x04 /* triv req/rsp, timestamp ignored */
> +#define SMB_COM_FLUSH                 0x05 /* triv req/rsp */
> +#define SMB_COM_DELETE                0x06 /* trivial response */
> +#define SMB_COM_RENAME                0x07 /* trivial response */
> +#define SMB_COM_QUERY_INFORMATION     0x08 /* aka getattr */
> +#define SMB_COM_SETATTR               0x09 /* trivial response */
> +#define SMB_COM_LOCKING_ANDX          0x24 /* trivial response */
> +#define SMB_COM_COPY                  0x29 /* trivial rsp, fail filename ignrd*/
> +#define SMB_COM_ECHO                  0x2B /* echo request */
> +#define SMB_COM_OPEN_ANDX             0x2D /* Legacy open for old servers */
> +#define SMB_COM_READ_ANDX             0x2E
> +#define SMB_COM_WRITE_ANDX            0x2F
> +#define SMB_COM_TRANSACTION2          0x32
> +#define SMB_COM_TRANSACTION2_SECONDARY 0x33
> +#define SMB_COM_FIND_CLOSE2           0x34 /* trivial response */
> +#define SMB_COM_TREE_DISCONNECT       0x71 /* trivial response */
> +#define SMB_COM_NEGOTIATE             0x72
> +#define SMB_COM_SESSION_SETUP_ANDX    0x73
> +#define SMB_COM_LOGOFF_ANDX           0x74 /* trivial response */
> +#define SMB_COM_TREE_CONNECT_ANDX     0x75
> +#define SMB_COM_NT_TRANSACT           0xA0
> +#define SMB_COM_NT_TRANSACT_SECONDARY 0xA1
> +#define SMB_COM_NT_CREATE_ANDX        0xA2
> +#define SMB_COM_NT_CANCEL             0xA4 /* no response */
> +#define SMB_COM_NT_RENAME             0xA5 /* trivial response */
> +
> +#define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
> +
> +/*
> + * SMB flag definitions
> + */
> +#define SMBFLG_EXTD_LOCK 0x01	/* server supports lock-read write-unlock smb */
> +#define SMBFLG_RCV_POSTED 0x02	/* obsolete */
> +#define SMBFLG_RSVD 0x04
> +#define SMBFLG_CASELESS 0x08	/* all pathnames treated as caseless (off
> +				implies case sensitive file handling request) */
> +#define SMBFLG_CANONICAL_PATH_FORMAT 0x10	/* obsolete */
> +#define SMBFLG_OLD_OPLOCK 0x20	/* obsolete */
> +#define SMBFLG_OLD_OPLOCK_NOTIFY 0x40	/* obsolete */
> +#define SMBFLG_RESPONSE 0x80	/* this PDU is a response from server */
> +
> +/*
> + * SMB flag2 definitions
> + */
> +#define SMBFLG2_KNOWS_LONG_NAMES cpu_to_le16(1)	/* can send long (non-8.3)
> +						   path names in response */
> +#define SMBFLG2_KNOWS_EAS cpu_to_le16(2)
> +#define SMBFLG2_SECURITY_SIGNATURE cpu_to_le16(4)
> +#define SMBFLG2_COMPRESSED (8)
> +#define SMBFLG2_SECURITY_SIGNATURE_REQUIRED (0x10)
> +#define SMBFLG2_IS_LONG_NAME cpu_to_le16(0x40)
> +#define SMBFLG2_REPARSE_PATH (0x400)
> +#define SMBFLG2_EXT_SEC cpu_to_le16(0x800)
> +#define SMBFLG2_DFS cpu_to_le16(0x1000)
> +#define SMBFLG2_PAGING_IO cpu_to_le16(0x2000)
> +#define SMBFLG2_ERR_STATUS cpu_to_le16(0x4000)
> +#define SMBFLG2_UNICODE cpu_to_le16(0x8000)
> +
> +/*
> + * File Attribute flags
> + */
> +#define ATTR_READONLY  0x0001
> +#define ATTR_HIDDEN    0x0002
> +#define ATTR_SYSTEM    0x0004
> +#define ATTR_VOLUME    0x0008
> +#define ATTR_DIRECTORY 0x0010
> +#define ATTR_ARCHIVE   0x0020
> +#define ATTR_DEVICE    0x0040
> +#define ATTR_NORMAL    0x0080
> +#define ATTR_TEMPORARY 0x0100
> +#define ATTR_SPARSE    0x0200
> +#define ATTR_REPARSE   0x0400
> +#define ATTR_COMPRESSED 0x0800
> +#define ATTR_OFFLINE    0x1000	/* ie file not immediately available -
> +					on offline storage */
> +#define ATTR_NOT_CONTENT_INDEXED 0x2000
> +#define ATTR_ENCRYPTED  0x4000
> +#define ATTR_POSIX_SEMANTICS 0x01000000
> +#define ATTR_BACKUP_SEMANTICS 0x02000000
> +#define ATTR_DELETE_ON_CLOSE 0x04000000
> +#define ATTR_SEQUENTIAL_SCAN 0x08000000
> +#define ATTR_RANDOM_ACCESS   0x10000000
> +#define ATTR_NO_BUFFERING    0x20000000
> +#define ATTR_WRITE_THROUGH   0x80000000
> +
> +struct smb_hdr {
> +	__be32 smb_buf_length;	/* BB length is only two (rarely three) bytes,
> +		with one or two byte "type" preceding it that will be
> +		zero - we could mask the type byte off */
> +	__u8 Protocol[4];
> +	__u8 Command;
> +	union {
> +		struct {
> +			__u8 ErrorClass;
> +			__u8 Reserved;
> +			__le16 Error;
> +		} __packed DosError;
> +		__le32 CifsError;
> +	} __packed Status;
> +	__u8 Flags;
> +	__le16 Flags2;		/* note: le */
> +	__le16 PidHigh;
> +	union {
> +		struct {
> +			__le32 SequenceNumber;  /* le */
> +			__u32 Reserved; /* zero */
> +		} __packed Sequence;
> +		__u8 SecuritySignature[8];	/* le */
> +	} __packed Signature;
> +	__u8 pad[2];
> +	__u16 Tid;
> +	__le16 Pid;
> +	__u16 Uid;
> +	__le16 Mid;
> +	__u8 WordCount;
> +} __packed;
> +
> +/* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
> +#define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
> +#define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
> +#define FILE_SUPPORT_INTEGRITY_STREAMS	0x04000000
> +#define FILE_SUPPORTS_USN_JOURNAL	0x02000000
> +#define FILE_SUPPORTS_OPEN_BY_FILE_ID	0x01000000
> +#define FILE_SUPPORTS_EXTENDED_ATTRIBUTES 0x00800000
> +#define FILE_SUPPORTS_HARD_LINKS	0x00400000
> +#define FILE_SUPPORTS_TRANSACTIONS	0x00200000
> +#define FILE_SEQUENTIAL_WRITE_ONCE	0x00100000
> +#define FILE_READ_ONLY_VOLUME		0x00080000
> +#define FILE_NAMED_STREAMS		0x00040000
> +#define FILE_SUPPORTS_ENCRYPTION	0x00020000
> +#define FILE_SUPPORTS_OBJECT_IDS	0x00010000
> +#define FILE_VOLUME_IS_COMPRESSED	0x00008000
> +#define FILE_SUPPORTS_POSIX_UNLINK_RENAME 0x00000400
> +#define FILE_RETURNS_CLEANUP_RESULT_INFO  0x00000200
> +#define FILE_SUPPORTS_REMOTE_STORAGE	0x00000100
> +#define FILE_SUPPORTS_REPARSE_POINTS	0x00000080
> +#define FILE_SUPPORTS_SPARSE_FILES	0x00000040
> +#define FILE_VOLUME_QUOTAS		0x00000020
> +#define FILE_FILE_COMPRESSION		0x00000010
> +#define FILE_PERSISTENT_ACLS		0x00000008
> +#define FILE_UNICODE_ON_DISK		0x00000004
> +#define FILE_CASE_PRESERVED_NAMES	0x00000002
> +#define FILE_CASE_SENSITIVE_SEARCH	0x00000001
> +
> +#endif /* _COMMON_SMB1_PDU_H */
> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
> index c3258a3231e4..810fad0303d7 100644
> --- a/fs/smb/server/smb_common.h
> +++ b/fs/smb/server/smb_common.h
> @@ -11,6 +11,7 @@
>   #include "glob.h"
>   #include "nterr.h"
>   #include "../common/smbglob.h"
> +#include "../common/smb1pdu.h"
>   #include "../common/smb2pdu.h"
>   #include "smb2pdu.h"
>   
> @@ -29,8 +30,6 @@
>   
>   #define SMB_ECHO_INTERVAL	(60 * HZ)
>   
> -#define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
> -
>   #define MAX_STREAM_PROT_LEN	0x00FFFFFF
>   
>   /* Responses when opening a file. */
> @@ -39,44 +38,6 @@
>   #define F_CREATED	2
>   #define F_OVERWRITTEN	3
>   
> -/*
> - * File Attribute flags
> - */
> -#define ATTR_POSIX_SEMANTICS		0x01000000
> -#define ATTR_BACKUP_SEMANTICS		0x02000000
> -#define ATTR_DELETE_ON_CLOSE		0x04000000
> -#define ATTR_SEQUENTIAL_SCAN		0x08000000
> -#define ATTR_RANDOM_ACCESS		0x10000000
> -#define ATTR_NO_BUFFERING		0x20000000
> -#define ATTR_WRITE_THROUGH		0x80000000
> -
> -/* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
> -#define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
> -#define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
> -#define FILE_SUPPORT_INTEGRITY_STREAMS	0x04000000
> -#define FILE_SUPPORTS_USN_JOURNAL	0x02000000
> -#define FILE_SUPPORTS_OPEN_BY_FILE_ID	0x01000000
> -#define FILE_SUPPORTS_EXTENDED_ATTRIBUTES 0x00800000
> -#define FILE_SUPPORTS_HARD_LINKS	0x00400000
> -#define FILE_SUPPORTS_TRANSACTIONS	0x00200000
> -#define FILE_SEQUENTIAL_WRITE_ONCE	0x00100000
> -#define FILE_READ_ONLY_VOLUME		0x00080000
> -#define FILE_NAMED_STREAMS		0x00040000
> -#define FILE_SUPPORTS_ENCRYPTION	0x00020000
> -#define FILE_SUPPORTS_OBJECT_IDS	0x00010000
> -#define FILE_VOLUME_IS_COMPRESSED	0x00008000
> -#define FILE_SUPPORTS_POSIX_UNLINK_RENAME 0x00000400
> -#define FILE_RETURNS_CLEANUP_RESULT_INFO  0x00000200
> -#define FILE_SUPPORTS_REMOTE_STORAGE	0x00000100
> -#define FILE_SUPPORTS_REPARSE_POINTS	0x00000080
> -#define FILE_SUPPORTS_SPARSE_FILES	0x00000040
> -#define FILE_VOLUME_QUOTAS		0x00000020
> -#define FILE_FILE_COMPRESSION		0x00000010
> -#define FILE_PERSISTENT_ACLS		0x00000008
> -#define FILE_UNICODE_ON_DISK		0x00000004
> -#define FILE_CASE_PRESERVED_NAMES	0x00000002
> -#define FILE_CASE_SENSITIVE_SEARCH	0x00000001
> -
>   #define FILE_READ_DATA        0x00000001  /* Data can be read from the file   */
>   #define FILE_WRITE_DATA       0x00000002  /* Data can be written to the file  */
>   #define FILE_APPEND_DATA      0x00000004  /* Data can be appended to the file */
> @@ -151,46 +112,8 @@
>   		FILE_EXECUTE | FILE_DELETE_CHILD | \
>   		FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
>   
> -#define SMB_COM_NEGOTIATE		0x72
>   #define SMB1_CLIENT_GUID_SIZE		(16)
>   
> -#define SMBFLG_RESPONSE 0x80	/* this PDU is a response from server */
> -
> -#define SMBFLG2_IS_LONG_NAME	cpu_to_le16(0x40)
> -#define SMBFLG2_EXT_SEC		cpu_to_le16(0x800)
> -#define SMBFLG2_ERR_STATUS	cpu_to_le16(0x4000)
> -#define SMBFLG2_UNICODE		cpu_to_le16(0x8000)
> -
> -struct smb_hdr {
> -	__be32 smb_buf_length;
> -	__u8 Protocol[4];
> -	__u8 Command;
> -	union {
> -		struct {
> -			__u8 ErrorClass;
> -			__u8 Reserved;
> -			__le16 Error;
> -		} __packed DosError;
> -		__le32 CifsError;
> -	} __packed Status;
> -	__u8 Flags;
> -	__le16 Flags2;          /* note: le */
> -	__le16 PidHigh;
> -	union {
> -		struct {
> -			__le32 SequenceNumber;  /* le */
> -			__u32 Reserved; /* zero */
> -		} __packed Sequence;
> -		__u8 SecuritySignature[8];      /* le */
> -	} __packed Signature;
> -	__u8 pad[2];
> -	__le16 Tid;
> -	__le16 Pid;
> -	__le16 Uid;
> -	__le16 Mid;
> -	__u8 WordCount;
> -} __packed;
> -
>   struct smb_negotiate_req {
>   	struct smb_hdr hdr;     /* wct = 0 */
>   	__le16 ByteCount;

