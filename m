Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2E01D5CEA;
	Tue,  4 Nov 2025 04:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762229088; cv=none; b=vCQDtKObETlj4cVYf5wtIn42OGkgiCQ990tRoY+N985FTv2kJarI2BHMt385mYSgN5Z4KBYocWyCLNn+4mVsWllW2uNmcRjTEfYSbXU+p9fJj0WssQgv8WI15p0iX90OUwwYPKIhDtNpEpS/I8OzDDMOXrdT5QK75ina5GUALaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762229088; c=relaxed/simple;
	bh=50EFM3VLhlY6tRGzSu3cE4A9cPGkWJONX9h8v2LPYFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UNaBbovsm3VdCF1+PEUFaXOySJmXTuGso8k/s//ns6s2I48KthZ8otndlQcXxtr6DNiFWVEWQUUYutWPgsW8eUB/ISPBmEtoaySKxcHF8As92j/7tDhDIWxuO5t42qZHRPN8ubQmNiRkjbawsireKAbCoA+sZ0tWGrviwi9zQdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 5daebf28b93311f0a38c85956e01ac42-20251104
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:10a6e4bc-9679-4d2a-ac8c-0bc9674e544c,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:a9d874c,CLOUDID:b20320344ef87c468d197925e96f4193,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5daebf28b93311f0a38c85956e01ac42-20251104
X-User: chenxiaosong@kylinos.cn
Received: from [10.42.20.206] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <chenxiaosong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 496572788; Tue, 04 Nov 2025 12:04:31 +0800
Message-ID: <00ab149e-1536-4e2f-ba64-763678f0f340@kylinos.cn>
Date: Tue, 4 Nov 2025 12:04:28 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/14] smb: move some duplicate definitions to
 common/smb2pdu.h
To: chenxiaosong.chenxiaosong@linux.dev, sfrench@samba.org,
 smfrench@gmail.com, linkinjeon@kernel.org, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ZhangGuoDong <zhangguodong@kylinos.cn>
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251102073059.3681026-8-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@kylinos.cn>
In-Reply-To: <20251102073059.3681026-8-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The struct smb_hdr seems to be used only by SMB1, while SMB2 and SMB3 
use smb2_hdr.

Therefore, smb_hdr should be moved to a new common/smb1pdu.h.

Thanks,
ChenXiaoSong.

On 11/2/25 15:30, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
> 
> In order to maintain the code more easily, move duplicate definitions to
> common header file.
> 
> There are only 4 different definitions, the client uses cpu_to_le16()
> but the server does not:
> 
>    - RSS_CAPABLE
>    - RDMA_CAPABLE
>    - INTERNETWORK
>    - INTERNETWORKV6
> 
> The other definitions are exactly the same on both client and server.
> 
> The struct smb_hdr is defined in MS-CIFS and MS-SMB, but it's also used by
> SMB2 and SMB3, so move it to the common smb2pdu.h.
> 
> Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> ---
>   fs/smb/client/cifspdu.h    | 135 +----------------------------
>   fs/smb/client/smb2pdu.h    |  21 -----
>   fs/smb/common/smb2pdu.h    | 172 +++++++++++++++++++++++++++++++++++--
>   fs/smb/server/smb2pdu.c    |   8 +-
>   fs/smb/server/smb2pdu.h    |  19 ----
>   fs/smb/server/smb_common.h |  75 +---------------
>   6 files changed, 173 insertions(+), 257 deletions(-)
> 
> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> index 2fb1eb2fff41..99cdba9f68dc 100644
> --- a/fs/smb/client/cifspdu.h
> +++ b/fs/smb/client/cifspdu.h
> @@ -12,6 +12,7 @@
>   #include <net/sock.h>
>   #include <linux/unaligned.h>
>   #include "../common/smbfsctl.h"
> +#include "../common/smb2pdu.h"
>   
>   #define CIFS_PROT   0
>   #define POSIX_PROT  (CIFS_PROT+1)
> @@ -179,98 +180,7 @@
>   #define SMBFLG2_ERR_STATUS cpu_to_le16(0x4000)
>   #define SMBFLG2_UNICODE cpu_to_le16(0x8000)
>   
> -/*
> - * These are the file access permission bits defined in CIFS for the
> - * NTCreateAndX as well as the level 0x107
> - * TRANS2_QUERY_PATH_INFORMATION API.  The level 0x107, SMB_QUERY_FILE_ALL_INFO
> - * responds with the AccessFlags.
> - * The AccessFlags specifies the access permissions a caller has to the
> - * file and can have any suitable combination of the following values:
> - */
> -
> -#define FILE_READ_DATA        0x00000001  /* Data can be read from the file   */
> -					  /* or directory child entries can   */
> -					  /* be listed together with the      */
> -					  /* associated child attributes      */
> -					  /* (so the FILE_READ_ATTRIBUTES on  */
> -					  /* the child entry is not needed)   */
> -#define FILE_WRITE_DATA       0x00000002  /* Data can be written to the file  */
> -					  /* or new file can be created in    */
> -					  /* the directory                    */
> -#define FILE_APPEND_DATA      0x00000004  /* Data can be appended to the file */
> -					  /* (for non-local files over SMB it */
> -					  /* is same as FILE_WRITE_DATA)      */
> -					  /* or new subdirectory can be       */
> -					  /* created in the directory         */
> -#define FILE_READ_EA          0x00000008  /* Extended attributes associated   */
> -					  /* with the file can be read        */
> -#define FILE_WRITE_EA         0x00000010  /* Extended attributes associated   */
> -					  /* with the file can be written     */
> -#define FILE_EXECUTE          0x00000020  /*Data can be read into memory from */
> -					  /* the file using system paging I/O */
> -					  /* for executing the file / script  */
> -					  /* or right to traverse directory   */
> -					  /* (but by default all users have   */
> -					  /* directory bypass traverse        */
> -					  /* privilege and do not need this   */
> -					  /* permission on directories at all)*/
> -#define FILE_DELETE_CHILD     0x00000040  /* Child entry can be deleted from  */
> -					  /* the directory (so the DELETE on  */
> -					  /* the child entry is not needed)   */
> -#define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes associated with the   */
> -					  /* file or directory can be read    */
> -#define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes associated with the   */
> -					  /* file or directory can be written */
> -#define DELETE                0x00010000  /* The file or dir can be deleted   */
> -#define READ_CONTROL          0x00020000  /* The discretionary access control */
> -					  /* list and ownership associated    */
> -					  /* with the file or dir can be read */
> -#define WRITE_DAC             0x00040000  /* The discretionary access control */
> -					  /* list associated with the file or */
> -					  /* directory can be written         */
> -#define WRITE_OWNER           0x00080000  /* Ownership information associated */
> -					  /* with the file/dir can be written */
> -#define SYNCHRONIZE           0x00100000  /* The file handle can waited on to */
> -					  /* synchronize with the completion  */
> -					  /* of an input/output request       */
> -#define SYSTEM_SECURITY       0x01000000  /* The system access control list   */
> -					  /* associated with the file or      */
> -					  /* directory can be read or written */
> -					  /* (cannot be in DACL, can in SACL) */
> -#define MAXIMUM_ALLOWED       0x02000000  /* Maximal subset of GENERIC_ALL    */
> -					  /* permissions which can be granted */
> -					  /* (cannot be in DACL nor SACL)     */
> -#define GENERIC_ALL           0x10000000  /* Same as: GENERIC_EXECUTE |       */
> -					  /*          GENERIC_WRITE |         */
> -					  /*          GENERIC_READ |          */
> -					  /*          FILE_DELETE_CHILD |     */
> -					  /*          DELETE |                */
> -					  /*          WRITE_DAC |             */
> -					  /*          WRITE_OWNER             */
> -					  /* So GENERIC_ALL contains all bits */
> -					  /* mentioned above except these two */
> -					  /* SYSTEM_SECURITY  MAXIMUM_ALLOWED */
> -#define GENERIC_EXECUTE       0x20000000  /* Same as: FILE_EXECUTE |          */
> -					  /*          FILE_READ_ATTRIBUTES |  */
> -					  /*          READ_CONTROL |          */
> -					  /*          SYNCHRONIZE             */
> -#define GENERIC_WRITE         0x40000000  /* Same as: FILE_WRITE_DATA |       */
> -					  /*          FILE_APPEND_DATA |      */
> -					  /*          FILE_WRITE_EA |         */
> -					  /*          FILE_WRITE_ATTRIBUTES | */
> -					  /*          READ_CONTROL |          */
> -					  /*          SYNCHRONIZE             */
> -#define GENERIC_READ          0x80000000  /* Same as: FILE_READ_DATA |        */
> -					  /*          FILE_READ_EA |          */
> -					  /*          FILE_READ_ATTRIBUTES |  */
> -					  /*          READ_CONTROL |          */
> -					  /*          SYNCHRONIZE             */
> -
> -#define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FILE_READ_ATTRIBUTES)
> -#define FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
> -				| FILE_WRITE_EA | FILE_WRITE_ATTRIBUTES)
> -#define FILE_EXEC_RIGHTS (FILE_EXECUTE)
> -
> +/* Combinations of file access permission bits */
>   #define SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FILE_WRITE_EA \
>   				| FILE_READ_ATTRIBUTES \
>   				| FILE_WRITE_ATTRIBUTES \
> @@ -282,15 +192,6 @@
>   				| FILE_WRITE_ATTRIBUTES \
>   				| DELETE | READ_CONTROL | WRITE_DAC \
>   				| WRITE_OWNER | SYNCHRONIZE)
> -#define SET_FILE_EXEC_RIGHTS (FILE_READ_EA | FILE_WRITE_EA | FILE_EXECUTE \
> -				| FILE_READ_ATTRIBUTES \
> -				| FILE_WRITE_ATTRIBUTES \
> -				| DELETE | READ_CONTROL | WRITE_DAC \
> -				| WRITE_OWNER | SYNCHRONIZE)
> -
> -#define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
> -				| READ_CONTROL | SYNCHRONIZE)
> -
>   
>   /*
>    * Invalid readdir handle
> @@ -416,38 +317,6 @@
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
> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> index 32da7a4773e1..98ed7a22cd57 100644
> --- a/fs/smb/client/smb2pdu.h
> +++ b/fs/smb/client/smb2pdu.h
> @@ -133,11 +133,6 @@ struct share_redirect_error_context_rsp {
>   #define SMB2_LEASE_HANDLE_CACHING_HE	0x02
>   #define SMB2_LEASE_WRITE_CACHING_HE	0x04
>   
> -
> -/* See MS-SMB2 2.2.13.2.11 */
> -/* Flags */
> -#define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
> -
>   /* See MS-SMB2 2.2.13.2.5 */
>   struct crt_twarp_ctxt {
>   	struct create_context_hdr ccontext;
> @@ -198,22 +193,6 @@ struct network_resiliency_req {
>   } __packed;
>   /* There is no buffer for the response ie no struct network_resiliency_rsp */
>   
> -#define RSS_CAPABLE	cpu_to_le32(0x00000001)
> -#define RDMA_CAPABLE	cpu_to_le32(0x00000002)
> -
> -#define INTERNETWORK	cpu_to_le16(0x0002)
> -#define INTERNETWORKV6	cpu_to_le16(0x0017)
> -
> -struct network_interface_info_ioctl_rsp {
> -	__le32 Next; /* next interface. zero if this is last one */
> -	__le32 IfIndex;
> -	__le32 Capability; /* RSS or RDMA Capable */
> -	__le32 Reserved;
> -	__le64 LinkSpeed;
> -	__le16 Family;
> -	__u8 Buffer[126];
> -} __packed;
> -
>   #define NO_FILE_ID 0xFFFFFFFFFFFFFFFFULL /* general ioctls to srv not to file */
>   
>   struct compress_ioctl {
> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> index 4ea515732b38..be1e652bb474 100644
> --- a/fs/smb/common/smb2pdu.h
> +++ b/fs/smb/common/smb2pdu.h
> @@ -1149,12 +1149,6 @@ struct smb2_server_client_notification {
>   #define FILE_OVERWRITE_IF_LE		cpu_to_le32(0x00000005)
>   #define FILE_CREATE_MASK_LE             cpu_to_le32(0x00000007)
>   
> -#define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
> -			| FILE_READ_ATTRIBUTES)
> -#define FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
> -			| FILE_WRITE_EA | FILE_WRITE_ATTRIBUTES)
> -#define FILE_EXEC_RIGHTS (FILE_EXECUTE)
> -
>   /* CreateOptions Flags */
>   #define FILE_DIRECTORY_FILE_LE		cpu_to_le32(0x00000001)
>   /* same as #define CREATE_NOT_FILE_LE	cpu_to_le32(0x00000001) */
> @@ -1290,6 +1284,14 @@ struct create_mxac_req {
>   	__le64 Timestamp;
>   } __packed;
>   
> +/*
> + * Flags
> + * See MS-SMB2 2.2.13.2.11
> + *     MS-SMB2 2.2.13.2.12
> + *     MS-SMB2 2.2.14.2.12
> + */
> +#define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
> +
>   /* See MS-SMB2 2.2.13.2.11 */
>   struct durable_context_v2_req {
>   	__le32 Timeout;
> @@ -1500,6 +1502,26 @@ struct smb_sockaddr_in6 {
>   	__be32 ScopeId;
>   } __packed;
>   
> +/* See MS-SMB2 2.2.32.5 and MS-SMB2 2.2.32.5.1 */
> +#define RSS_CAPABLE	cpu_to_le32(0x00000001)
> +#define RDMA_CAPABLE	cpu_to_le32(0x00000002)
> +#define INTERNETWORK	cpu_to_le16(0x0002)
> +#define INTERNETWORKV6	cpu_to_le16(0x0017)
> +struct network_interface_info_ioctl_rsp {
> +	__le32 Next; /* next interface. zero if this is last one */
> +	__le32 IfIndex;
> +	__le32 Capability; /* RSS or RDMA Capable */
> +	__le32 Reserved;
> +	__le64 LinkSpeed;
> +	union {
> +		char	SockAddr_Storage[128];
> +		struct {
> +			__le16 Family;
> +			__u8 Buffer[126];
> +		};
> +	};
> +} __packed;
> +
>   /* this goes in the ioctl buffer when doing FSCTL_SET_ZERO_DATA */
>   struct file_zero_data_information {
>   	__le64	FileOffset;
> @@ -1989,6 +2011,144 @@ struct smb2_lease_ack {
>   	__le64 LeaseDuration;
>   } __packed;
>   
> +/*
> + * See MS-CIFS 2.2.3.1
> + *     MS-SMB 2.2.3.1
> + */
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
>   #define OP_BREAK_STRUCT_SIZE_20		24
>   #define OP_BREAK_STRUCT_SIZE_21		36
> +
> +/*
> + * See MS-SMB2 2.2.13.1.1
> + *     MS-SMB 2.2.1.4.1
> + * These are the file access permission bits defined in CIFS for the
> + * NTCreateAndX as well as the level 0x107
> + * TRANS2_QUERY_PATH_INFORMATION API.  The level 0x107, SMB_QUERY_FILE_ALL_INFO
> + * responds with the AccessFlags.
> + * The AccessFlags specifies the access permissions a caller has to the
> + * file and can have any suitable combination of the following values:
> + */
> +#define FILE_READ_DATA        0x00000001  /* Data can be read from the file   */
> +					  /* or directory child entries can   */
> +					  /* be listed together with the      */
> +					  /* associated child attributes      */
> +					  /* (so the FILE_READ_ATTRIBUTES on  */
> +					  /* the child entry is not needed)   */
> +#define FILE_WRITE_DATA       0x00000002  /* Data can be written to the file  */
> +					  /* or new file can be created in    */
> +					  /* the directory                    */
> +#define FILE_APPEND_DATA      0x00000004  /* Data can be appended to the file */
> +					  /* (for non-local files over SMB it */
> +					  /* is same as FILE_WRITE_DATA)      */
> +					  /* or new subdirectory can be       */
> +					  /* created in the directory         */
> +#define FILE_READ_EA          0x00000008  /* Extended attributes associated   */
> +					  /* with the file can be read        */
> +#define FILE_WRITE_EA         0x00000010  /* Extended attributes associated   */
> +					  /* with the file can be written     */
> +#define FILE_EXECUTE          0x00000020  /*Data can be read into memory from */
> +					  /* the file using system paging I/O */
> +					  /* for executing the file / script  */
> +					  /* or right to traverse directory   */
> +					  /* (but by default all users have   */
> +					  /* directory bypass traverse        */
> +					  /* privilege and do not need this   */
> +					  /* permission on directories at all)*/
> +#define FILE_DELETE_CHILD     0x00000040  /* Child entry can be deleted from  */
> +					  /* the directory (so the DELETE on  */
> +					  /* the child entry is not needed)   */
> +#define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes associated with the   */
> +					  /* file or directory can be read    */
> +#define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes associated with the   */
> +					  /* file or directory can be written */
> +#define DELETE                0x00010000  /* The file or dir can be deleted   */
> +#define READ_CONTROL          0x00020000  /* The discretionary access control */
> +					  /* list and ownership associated    */
> +					  /* with the file or dir can be read */
> +#define WRITE_DAC             0x00040000  /* The discretionary access control */
> +					  /* list associated with the file or */
> +					  /* directory can be written         */
> +#define WRITE_OWNER           0x00080000  /* Ownership information associated */
> +					  /* with the file/dir can be written */
> +#define SYNCHRONIZE           0x00100000  /* The file handle can waited on to */
> +					  /* synchronize with the completion  */
> +					  /* of an input/output request       */
> +#define SYSTEM_SECURITY       0x01000000  /* The system access control list   */
> +					  /* associated with the file or      */
> +					  /* directory can be read or written */
> +					  /* (cannot be in DACL, can in SACL) */
> +#define MAXIMUM_ALLOWED       0x02000000  /* Maximal subset of GENERIC_ALL    */
> +					  /* permissions which can be granted */
> +					  /* (cannot be in DACL nor SACL)     */
> +#define GENERIC_ALL           0x10000000  /* Same as: GENERIC_EXECUTE |       */
> +					  /*          GENERIC_WRITE |         */
> +					  /*          GENERIC_READ |          */
> +					  /*          FILE_DELETE_CHILD |     */
> +					  /*          DELETE |                */
> +					  /*          WRITE_DAC |             */
> +					  /*          WRITE_OWNER             */
> +					  /* So GENERIC_ALL contains all bits */
> +					  /* mentioned above except these two */
> +					  /* SYSTEM_SECURITY  MAXIMUM_ALLOWED */
> +#define GENERIC_EXECUTE       0x20000000  /* Same as: FILE_EXECUTE |          */
> +					  /*          FILE_READ_ATTRIBUTES |  */
> +					  /*          READ_CONTROL |          */
> +					  /*          SYNCHRONIZE             */
> +#define GENERIC_WRITE         0x40000000  /* Same as: FILE_WRITE_DATA |       */
> +					  /*          FILE_APPEND_DATA |      */
> +					  /*          FILE_WRITE_EA |         */
> +					  /*          FILE_WRITE_ATTRIBUTES | */
> +					  /*          READ_CONTROL |          */
> +					  /*          SYNCHRONIZE             */
> +#define GENERIC_READ          0x80000000  /* Same as: FILE_READ_DATA |        */
> +					  /*          FILE_READ_EA |          */
> +					  /*          FILE_READ_ATTRIBUTES |  */
> +					  /*          READ_CONTROL |          */
> +					  /*          SYNCHRONIZE             */
> +
> +/* Combinations of file access permission bits */
> +#define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FILE_READ_ATTRIBUTES)
> +#define FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
> +			| FILE_WRITE_EA | FILE_WRITE_ATTRIBUTES)
> +#define FILE_EXEC_RIGHTS (FILE_EXECUTE)
> +#define SET_FILE_EXEC_RIGHTS (FILE_READ_EA | FILE_WRITE_EA | FILE_EXECUTE \
> +				| FILE_READ_ATTRIBUTES \
> +				| FILE_WRITE_ATTRIBUTES \
> +				| DELETE | READ_CONTROL | WRITE_DAC \
> +				| WRITE_OWNER | SYNCHRONIZE)
> +#define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
> +				| READ_CONTROL | SYNCHRONIZE)
> +
>   #endif				/* _COMMON_SMB2PDU_H */
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index b95ca0de60c3..3c2ddf0da344 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -7876,9 +7876,9 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
>   
>   		nii_rsp->Capability = 0;
>   		if (netdev->real_num_tx_queues > 1)
> -			nii_rsp->Capability |= cpu_to_le32(RSS_CAPABLE);
> +			nii_rsp->Capability |= RSS_CAPABLE;
>   		if (ksmbd_rdma_capable_netdev(netdev))
> -			nii_rsp->Capability |= cpu_to_le32(RDMA_CAPABLE);
> +			nii_rsp->Capability |= RDMA_CAPABLE;
>   
>   		nii_rsp->Next = cpu_to_le32(152);
>   		nii_rsp->Reserved = 0;
> @@ -7904,7 +7904,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
>   		if (!ipv4_set) {
>   			struct in_device *idev;
>   
> -			sockaddr_storage->Family = cpu_to_le16(INTERNETWORK);
> +			sockaddr_storage->Family = INTERNETWORK;
>   			sockaddr_storage->addr4.Port = 0;
>   
>   			idev = __in_dev_get_rtnl(netdev);
> @@ -7920,7 +7920,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
>   			struct inet6_ifaddr *ifa;
>   			__u8 *ipv6_addr = sockaddr_storage->addr6.IPv6Address;
>   
> -			sockaddr_storage->Family = cpu_to_le16(INTERNETWORKV6);
> +			sockaddr_storage->Family = INTERNETWORKV6;
>   			sockaddr_storage->addr6.Port = 0;
>   			sockaddr_storage->addr6.FlowInfo = 0;
>   
> diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
> index 7758aa01034d..acaf5955eec1 100644
> --- a/fs/smb/server/smb2pdu.h
> +++ b/fs/smb/server/smb2pdu.h
> @@ -83,10 +83,6 @@ struct create_durable_rsp {
>   	} Data;
>   } __packed;
>   
> -/* See MS-SMB2 2.2.13.2.11 */
> -/* Flags */
> -#define SMB2_DHANDLE_FLAG_PERSISTENT	0x00000002
> -
>   /* equivalent of the contents of SMB3.1.1 POSIX open context response */
>   struct create_posix_rsp {
>   	struct create_context_hdr ccontext;
> @@ -100,9 +96,6 @@ struct create_posix_rsp {
>   
>   #define SMB2_0_IOCTL_IS_FSCTL 0x00000001
>   
> -#define INTERNETWORK	0x0002
> -#define INTERNETWORKV6	0x0017
> -
>   struct sockaddr_storage_rsp {
>   	__le16 Family;
>   	union {
> @@ -111,18 +104,6 @@ struct sockaddr_storage_rsp {
>   	};
>   } __packed;
>   
> -#define RSS_CAPABLE	0x00000001
> -#define RDMA_CAPABLE	0x00000002
> -
> -struct network_interface_info_ioctl_rsp {
> -	__le32 Next; /* next interface. zero if this is last one */
> -	__le32 IfIndex;
> -	__le32 Capability; /* RSS or RDMA Capable */
> -	__le32 Reserved;
> -	__le64 LinkSpeed;
> -	char	SockAddr_Storage[128];
> -} __packed;
> -
>   struct file_object_buf_type1_ioctl_rsp {
>   	__u8 ObjectId[16];
>   	__u8 BirthVolumeId[16];
> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
> index a2c7ab994fb1..1928b66d309f 100644
> --- a/fs/smb/server/smb_common.h
> +++ b/fs/smb/server/smb_common.h
> @@ -75,42 +75,7 @@
>   #define FILE_CASE_PRESERVED_NAMES	0x00000002
>   #define FILE_CASE_SENSITIVE_SEARCH	0x00000001
>   
> -#define FILE_READ_DATA        0x00000001  /* Data can be read from the file   */
> -#define FILE_WRITE_DATA       0x00000002  /* Data can be written to the file  */
> -#define FILE_APPEND_DATA      0x00000004  /* Data can be appended to the file */
> -#define FILE_READ_EA          0x00000008  /* Extended attributes associated   */
> -/* with the file can be read        */
> -#define FILE_WRITE_EA         0x00000010  /* Extended attributes associated   */
> -/* with the file can be written     */
> -#define FILE_EXECUTE          0x00000020  /*Data can be read into memory from */
> -/* the file using system paging I/O */
> -#define FILE_DELETE_CHILD     0x00000040
> -#define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes associated with the   */
> -/* file can be read                 */
> -#define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes associated with the   */
> -/* file can be written              */
> -#define DELETE                0x00010000  /* The file can be deleted          */
> -#define READ_CONTROL          0x00020000  /* The access control list and      */
> -/* ownership associated with the    */
> -/* file can be read                 */
> -#define WRITE_DAC             0x00040000  /* The access control list and      */
> -/* ownership associated with the    */
> -/* file can be written.             */
> -#define WRITE_OWNER           0x00080000  /* Ownership information associated */
> -/* with the file can be written     */
> -#define SYNCHRONIZE           0x00100000  /* The file handle can waited on to */
> -/* synchronize with the completion  */
> -/* of an input/output request       */
> -#define GENERIC_ALL           0x10000000
> -#define GENERIC_EXECUTE       0x20000000
> -#define GENERIC_WRITE         0x40000000
> -#define GENERIC_READ          0x80000000
> -/* In summary - Relevant file       */
> -/* access flags from CIFS are       */
> -/* file_read_data, file_write_data  */
> -/* file_execute, file_read_attributes*/
> -/* write_dac, and delete.           */
> -
> +/* Combinations of file access permission bits */
>   #define SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
>   		| FILE_READ_ATTRIBUTES \
>   		| DELETE | READ_CONTROL | WRITE_DAC \
> @@ -121,14 +86,6 @@
>   		| FILE_WRITE_ATTRIBUTES \
>   		| DELETE | READ_CONTROL | WRITE_DAC \
>   		| WRITE_OWNER | SYNCHRONIZE)
> -#define SET_FILE_EXEC_RIGHTS (FILE_READ_EA | FILE_WRITE_EA | FILE_EXECUTE \
> -		| FILE_READ_ATTRIBUTES \
> -		| FILE_WRITE_ATTRIBUTES \
> -		| DELETE | READ_CONTROL | WRITE_DAC \
> -		| WRITE_OWNER | SYNCHRONIZE)
> -
> -#define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
> -		| READ_CONTROL | SYNCHRONIZE)
>   
>   /* generic flags for file open */
>   #define GENERIC_READ_FLAGS	(READ_CONTROL | FILE_READ_DATA | \
> @@ -159,36 +116,6 @@
>   #define SMBFLG2_ERR_STATUS	cpu_to_le16(0x4000)
>   #define SMBFLG2_UNICODE		cpu_to_le16(0x8000)
>   
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

