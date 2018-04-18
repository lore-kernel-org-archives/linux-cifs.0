From: Tom Talpey <tom@talpey.com>
Subject: Re: [Patch v3 2/6] cifs: Allocate validate negotiation request
 through kmalloc
Date: Wed, 18 Apr 2018 13:42:44 -0400
Message-ID: <aabd22d8-3644-6987-1d51-5592f9e04ced@talpey.com>
References: <20180418003358.25098-1-longli@linuxonhyperv.com>
 <d7e569b6-d268-b8c1-e91d-d6dc0e7cdfc2@talpey.com>
 <MWHPR2101MB07298108AA78EBC4B8D10B4BCEB60@MWHPR2101MB0729.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>
To: Long Li <longli@microsoft.com>, Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR2101MB07298108AA78EBC4B8D10B4BCEB60@MWHPR2101MB0729.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 4/18/2018 1:16 PM, Long Li wrote:
>> Subject: Re: [Patch v3 2/6] cifs: Allocate validate negotiation request through
>> kmalloc
>>
>> Two comments.
>>
>> On 4/17/2018 8:33 PM, Long Li wrote:
>>> From: Long Li <longli@microsoft.com>
>>>
>>> The data buffer allocated on the stack can't be DMA'ed, and hence
>>> can't send through RDMA via SMB Direct.
>>
>> This comment is confusing. Any registered memory can be DMA'd, need to
>> state the reason for the choice here more clearly.
>>
>>>
>>> Fix this by allocating the request on the heap in smb3_validate_negotiate.
>>>
>>> Changes in v2:
>>> Removed duplicated code on freeing buffers on function exit.
>>> (Thanks to Parav Pandit <parav@mellanox.com>) Fixed typo in the patch
>>> title.
>>>
>>> Changes in v3:
>>> Added "Fixes" to the patch.
>>> Changed sizeof() to use *pointer in place of struct.
>>>
>>> Fixes: ff1c038addc4 ("Check SMB3 dialects against downgrade attacks")
>>> Signed-off-by: Long Li <longli@microsoft.com>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>    fs/cifs/smb2pdu.c | 59 ++++++++++++++++++++++++++++++--------------
>> -----------
>>>    1 file changed, 32 insertions(+), 27 deletions(-)
>>>
>>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c index
>>> 0f044c4..5582a02 100644
>>> --- a/fs/cifs/smb2pdu.c
>>> +++ b/fs/cifs/smb2pdu.c
>>> @@ -729,8 +729,8 @@ SMB2_negotiate(const unsigned int xid, struct
>>> cifs_ses *ses)
>>>
>>>    int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>>>    {
>>> -	int rc = 0;
>>> -	struct validate_negotiate_info_req vneg_inbuf;
>>> +	int ret, rc = -EIO;
>>> +	struct validate_negotiate_info_req *pneg_inbuf;
>>>    	struct validate_negotiate_info_rsp *pneg_rsp = NULL;
>>>    	u32 rsplen;
>>>    	u32 inbuflen; /* max of 4 dialects */ @@ -741,6 +741,9 @@ int
>>> smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>>>    	if (tcon->ses->server->rdma)
>>>    		return 0;
>>>    #endif
>>> +	pneg_inbuf = kmalloc(sizeof(*pneg_inbuf), GFP_KERNEL);
>>> +	if (!pneg_inbuf)
>>> +		return -ENOMEM;
>>
>> Why is this a nonblocking allocation? It would seem more robust to use
>> GFP_NOFS here.
> 
> I agree it makes sense to use GFP_NOFS.
> 
> The choice here is made consistent with all the rest CIFS code allocating protocol request buffers. Maybe we should do another patch to cleanup all those code.

It'll be required sooner or later. I'm agnostic as to how you apply it,
but I still suggest you change this one now rather than continue the
fragile behavior. It may not be a global search-and-replace since some
allocations may require nonblocking.


> 
>>
>> Tom.
>>
>>>
>>>    	/* In SMB3.11 preauth integrity supersedes validate negotiate */
>>>    	if (tcon->ses->server->dialect == SMB311_PROT_ID) @@ -764,63
>>> +767,63 @@ int smb3_validate_negotiate(const unsigned int xid, struct
>> cifs_tcon *tcon)
>>>    	if (tcon->ses->session_flags & SMB2_SESSION_FLAG_IS_NULL)
>>>    		cifs_dbg(VFS, "Unexpected null user (anonymous) auth flag
>> sent by
>>> server\n");
>>>
>>> -	vneg_inbuf.Capabilities =
>>> +	pneg_inbuf->Capabilities =
>>>    			cpu_to_le32(tcon->ses->server->vals-
>>> req_capabilities);
>>> -	memcpy(vneg_inbuf.Guid, tcon->ses->server->client_guid,
>>> +	memcpy(pneg_inbuf->Guid, tcon->ses->server->client_guid,
>>>    					SMB2_CLIENT_GUID_SIZE);
>>>
>>>    	if (tcon->ses->sign)
>>> -		vneg_inbuf.SecurityMode =
>>> +		pneg_inbuf->SecurityMode =
>>>
>> 	cpu_to_le16(SMB2_NEGOTIATE_SIGNING_REQUIRED);
>>>    	else if (global_secflags & CIFSSEC_MAY_SIGN)
>>> -		vneg_inbuf.SecurityMode =
>>> +		pneg_inbuf->SecurityMode =
>>>
>> 	cpu_to_le16(SMB2_NEGOTIATE_SIGNING_ENABLED);
>>>    	else
>>> -		vneg_inbuf.SecurityMode = 0;
>>> +		pneg_inbuf->SecurityMode = 0;
>>>
>>>
>>>    	if (strcmp(tcon->ses->server->vals->version_string,
>>>    		SMB3ANY_VERSION_STRING) == 0) {
>>> -		vneg_inbuf.Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
>>> -		vneg_inbuf.Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
>>> -		vneg_inbuf.DialectCount = cpu_to_le16(2);
>>> +		pneg_inbuf->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
>>> +		pneg_inbuf->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
>>> +		pneg_inbuf->DialectCount = cpu_to_le16(2);
>>>    		/* structure is big enough for 3 dialects, sending only 2 */
>>>    		inbuflen = sizeof(struct validate_negotiate_info_req) - 2;
>>>    	} else if (strcmp(tcon->ses->server->vals->version_string,
>>>    		SMBDEFAULT_VERSION_STRING) == 0) {
>>> -		vneg_inbuf.Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
>>> -		vneg_inbuf.Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
>>> -		vneg_inbuf.Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
>>> -		vneg_inbuf.DialectCount = cpu_to_le16(3);
>>> +		pneg_inbuf->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
>>> +		pneg_inbuf->Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
>>> +		pneg_inbuf->Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
>>> +		pneg_inbuf->DialectCount = cpu_to_le16(3);
>>>    		/* structure is big enough for 3 dialects */
>>>    		inbuflen = sizeof(struct validate_negotiate_info_req);
>>>    	} else {
>>>    		/* otherwise specific dialect was requested */
>>> -		vneg_inbuf.Dialects[0] =
>>> +		pneg_inbuf->Dialects[0] =
>>>    			cpu_to_le16(tcon->ses->server->vals->protocol_id);
>>> -		vneg_inbuf.DialectCount = cpu_to_le16(1);
>>> +		pneg_inbuf->DialectCount = cpu_to_le16(1);
>>>    		/* structure is big enough for 3 dialects, sending only 1 */
>>>    		inbuflen = sizeof(struct validate_negotiate_info_req) - 4;
>>>    	}
>>>
>>> -	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>>> +	ret = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>>>    		FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
>>> -		(char *)&vneg_inbuf, sizeof(struct
>> validate_negotiate_info_req),
>>> +		(char *)pneg_inbuf, sizeof(*pneg_inbuf),
>>>    		(char **)&pneg_rsp, &rsplen);
>>>
>>> -	if (rc != 0) {
>>> -		cifs_dbg(VFS, "validate protocol negotiate failed: %d\n", rc);
>>> -		return -EIO;
>>> +	if (ret) {
>>> +		cifs_dbg(VFS, "validate protocol negotiate failed: %d\n", ret);
>>> +		goto out_free_inbuf;
>>>    	}
>>>
>>> -	if (rsplen != sizeof(struct validate_negotiate_info_rsp)) {
>>> +	if (rsplen != sizeof(*pneg_rsp)) {
>>>    		cifs_dbg(VFS, "invalid protocol negotiate response
>> size: %d\n",
>>>    			 rsplen);
>>>
>>>    		/* relax check since Mac returns max bufsize allowed on ioctl
>> */
>>>    		if ((rsplen > CIFSMaxBufSize)
>>>    		     || (rsplen < sizeof(struct validate_negotiate_info_rsp)))
>>> -			goto err_rsp_free;
>>> +			goto out_free_rsp;
>>>    	}
>>>
>>>    	/* check validate negotiate info response matches what we got
>>> earlier */ @@ -838,14 +841,16 @@ int smb3_validate_negotiate(const
>>> unsigned int xid, struct cifs_tcon *tcon)
>>>
>>>    	/* validate negotiate successful */
>>>    	cifs_dbg(FYI, "validate negotiate info successful\n");
>>> -	kfree(pneg_rsp);
>>> -	return 0;
>>> +	rc = 0;
>>> +	goto out_free_rsp;
>>>
>>>    vneg_out:
>>>    	cifs_dbg(VFS, "protocol revalidation - security settings
>>> mismatch\n");
>>> -err_rsp_free:
>>> +out_free_rsp:
>>>    	kfree(pneg_rsp);
>>> -	return -EIO;
>>> +out_free_inbuf:
>>> +	kfree(pneg_inbuf);
>>> +	return rc;
>>>    }
>>>
>>>    enum securityEnum
>>>
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{��ٚ�{ay�
ʇڙ�,j��f���h���z�
�w���
���j:+v���w�j�m��������zZ+�����ݢj"��!tml=
> 
