From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCHv2] [CIFS] Allow setting per-file compression via CIFS protocol
Date: Mon, 14 Oct 2013 15:35:48 -0500
Message-ID: <CAH2r5msJ5RuOHWWhQg5ec_utRDXi6U7eYgtVhQYq1zjGbf4uSg@mail.gmail.com>
References: <CAH2r5mu+PiSKxB9GhyHApo4Gkj-p7jP+mT9rQB+5_RA2TF4rYg@mail.gmail.com>
	<20131014072150.1f7cb240@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Stefan \(metze\) Metzmacher" <metze@samba.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>
To: Jeff Layton <jlayton@redhat.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20131014072150.1f7cb240@tlielax.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

updated in cifs-2.6.git for-next with Jeff's suggestions

On Mon, Oct 14, 2013 at 6:21 AM, Jeff Layton <jlayton@redhat.com> wrote:
> On Sun, 13 Oct 2013 22:33:07 -0500
> Steve French <smfrench@gmail.com> wrote:
>
>> (PATCHv2 updated to address build problem with SMB2 disabled in .config)
>>
>> An earlier patch allowed setting the per-file compression flag
>>
>> "chattr +c filename"
>>
>> on an smb2 or smb3 mount, and also allowed lsattr to return
>> whether a file on a cifs, or smb2/smb3 mount was compressed.
>>
>> This patch extends the ability to set the per-file
>> compression flag to the cifs protocol, which uses a somewhat
>> different IOCTL mechanism than SMB2, although the payload
>> (the flags stored in the compression_state) are the same.
>>
>> Signed-off-by: Steve French <smfrench@gmail.com>
>> ---
>>  fs/cifs/cifspdu.h   | 29 +++++++++++++++++++++++++++++
>>  fs/cifs/cifsproto.h |  2 ++
>>  fs/cifs/cifssmb.c   | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/cifs/smb1ops.c   |  8 ++++++++
>>  fs/cifs/smb2pdu.h   |  9 ++++++---
>>  5 files changed, 98 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
>> index d40bd77..f9bb497 100644
>> --- a/fs/cifs/cifspdu.h
>> +++ b/fs/cifs/cifspdu.h
>> @@ -1352,6 +1352,35 @@ typedef struct smb_com_transaction_ioctl_req {
>>      __u8 Data[1];
>>  } __attribute__((packed)) TRANSACT_IOCTL_REQ;
>>
>> +typedef struct smb_com_transaction_compr_ioctl_req {
>> +    struct smb_hdr hdr;    /* wct = 23 */
>> +    __u8 MaxSetupCount;
>> +    __u16 Reserved;
>> +    __le32 TotalParameterCount;
>> +    __le32 TotalDataCount;
>> +    __le32 MaxParameterCount;
>> +    __le32 MaxDataCount;
>> +    __le32 ParameterCount;
>> +    __le32 ParameterOffset;
>> +    __le32 DataCount;
>> +    __le32 DataOffset;
>> +    __u8 SetupCount; /* four setup words follow subcommand */
>> +    /* SNIA spec incorrectly included spurious pad here */
>> +    __le16 SubCommand; /* 2 = IOCTL/FSCTL */
>> +    __le32 FunctionCode;
>> +    __u16 Fid;
>> +    __u8 IsFsctl;  /* 1 = File System Control 0 = device control (IOCTL) */
>> +    __u8 IsRootFlag; /* 1 = apply command to root of share (must be DFS) */
>> +    __le16 ByteCount;
>> +    __u8 Pad[3];
>> +    __le16 compression_state;  /* See below for valid flags */
>> +} __attribute__((packed)) TRANSACT_COMPR_IOCTL_REQ;
>> +
>> +/* compression state flags */
>> +#define COMPRESSION_FORMAT_NONE        0x0000
>> +#define COMPRESSION_FORMAT_DEFAULT    0x0001
>> +#define COMPRESSION_FORMAT_LZNT1    0x0002
>> +
>>  typedef struct smb_com_transaction_ioctl_rsp {
>>      struct smb_hdr hdr;    /* wct = 19 */
>>      __u8 Reserved[3];
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index b5ec2a2..aa33976 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -360,6 +360,8 @@ extern int CIFSSMBUnixQuerySymLink(const unsigned int xid,
>>  extern int CIFSSMBQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
>>                     __u16 fid, char **symlinkinfo,
>>                     const struct nls_table *nls_codepage);
>> +extern int CIFSSMB_set_compression(const unsigned int xid,
>> +                   struct cifs_tcon *tcon, __u16 fid);
>>  extern int CIFSSMBOpen(const unsigned int xid, struct cifs_tcon *tcon,
>>              const char *fileName, const int disposition,
>>              const int access_flags, const int omode,
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index ccd31ab..ec57dde 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -3199,6 +3199,59 @@ qreparse_out:
>>      return rc;
>>  }
>>
>> +int
>> +CIFSSMB_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
>> +            __u16 fid)
>> +{
>> +    int rc = 0;
>> +    int bytes_returned;
>> +    struct smb_com_transaction_compr_ioctl_req *pSMB;
>> +    struct smb_com_transaction_ioctl_rsp *pSMBr;
>> +
>> +    cifs_dbg(FYI, "Set compression for %u\n", fid);
>> +    rc = smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **) &pSMB,
>> +              (void **) &pSMBr);
>> +    if (rc)
>> +        return rc;
>> +
>> +    pSMB->compression_state = cpu_to_le16(COMPRESSION_FORMAT_DEFAULT);
>> +
>> +    pSMB->TotalParameterCount = 0;
>> +    pSMB->TotalDataCount = cpu_to_le32(2);
>
> Most of these sorts of calls where you're plugging in hardcoded values
> can be "__constant_cpu_to_le32(...)".
>
>> +    pSMB->MaxParameterCount = 0;
>> +    pSMB->MaxDataCount = 0;
>> +    pSMB->MaxSetupCount = 4;
>> +    pSMB->Reserved = 0;
>> +    pSMB->ParameterOffset = 0;
>> +    pSMB->DataCount = cpu_to_le32(2);
>> +    pSMB->DataOffset =
>> +        cpu_to_le32(offsetof(struct smb_com_transaction_compr_ioctl_req,
>> +                compression_state) - 4);  /* 84 */
>> +    pSMB->SetupCount = 4;
>> +    pSMB->SubCommand = cpu_to_le16(NT_TRANSACT_IOCTL);
>> +    pSMB->ParameterCount = 0;
>> +    pSMB->FunctionCode = cpu_to_le32(FSCTL_SET_COMPRESSION);
>> +    pSMB->IsFsctl = 1; /* FSCTL */
>> +    pSMB->IsRootFlag = 0;
>> +    pSMB->Fid = fid; /* file handle always le */
>> +    pSMB->ByteCount = cpu_to_le16(5); /* 3 byte pad 2 byte compress state */
>> +    inc_rfc1001_len(pSMB, 5);
>> +
>> +    rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>> +             (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>> +    if (rc)
>> +        cifs_dbg(FYI, "Send error in SetCompression = %d\n", rc);
>> +
>> +    cifs_buf_release(pSMB);
>> +
>> +    /*
>> +     * Note: On -EAGAIN error only caller can retry on handle based calls
>> +     * since file handle passed in no longer valid.
>> +     */
>> +    return rc;
>> +}
>> +
>> +
>>  #ifdef CONFIG_CIFS_POSIX
>>
>>  /*Convert an Access Control Entry from wire format to local POSIX
>> xattr format*/
>> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
>> index 8233b17..ea99efe 100644
>> --- a/fs/cifs/smb1ops.c
>> +++ b/fs/cifs/smb1ops.c
>> @@ -807,6 +807,13 @@ out:
>>  }
>>
>>  static int
>> +cifs_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
>> +           struct cifsFileInfo *cfile)
>> +{
>> +    return CIFSSMB_set_compression(xid, tcon, cfile->fid.netfid);
>> +}
>> +
>> +static int
>>  cifs_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
>>               const char *path, struct cifs_sb_info *cifs_sb,
>>               struct cifs_fid *fid, __u16 search_flags,
>> @@ -956,6 +963,7 @@ struct smb_version_operations smb1_operations = {
>>      .set_path_size = CIFSSMBSetEOF,
>>      .set_file_size = CIFSSMBSetFileSize,
>>      .set_file_info = smb_set_file_info,
>> +    .set_compression = cifs_set_compression,
>>      .echo = CIFSSMBEcho,
>>      .mkdir = CIFSSMBMkDir,
>>      .mkdir_setinfo = cifs_mkdir_setinfo,
>> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
>> index 7e44f18..2a72ef2 100644
>> --- a/fs/cifs/smb2pdu.h
>> +++ b/fs/cifs/smb2pdu.h
>> @@ -573,9 +573,12 @@ struct compress_ioctl {
>>      __le16 CompressionState;
>>  } __packed;
>>
>> -#define COMPRESSION_FORMAT_NONE        0x0000
>> -#define COMPRESSION_FORMAT_DEFAULT    0x0001
>> -#define COMPRESSION_FORMAT_LZNT1    0x0002
>> +/*
>> + * These defines have been moved to cifspdu.h
>> + * #define COMPRESSION_FORMAT_NONE    0x0000
>> + * #define COMPRESSION_FORMAT_DEFAULT    0x0001
>> + * #define COMPRESSION_FORMAT_LZNT1    0x0002
>> + */
>
> Just remove these instead of commenting them out, please.
>
>>  struct smb2_ioctl_req {
>>      struct smb2_hdr hdr;
>>      __le16 StructureSize;    /* Must be 57 */
>
>
> Looks good otherwise...
>
> Acked-by: Jeff Layton <jlayton@redhat.com>



-- 
Thanks,

Steve
