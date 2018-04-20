From: Tom Talpey <tom@talpey.com>
Subject: Re: [Patch v4] cifs: Allocate validate negotiation request through
 kmalloc
Date: Fri, 20 Apr 2018 14:50:22 -0400
Message-ID: <1734dfc1-acef-def8-9aa9-1b9960d26f94@talpey.com>
References: <20180419213807.3128-1-longli@linuxonhyperv.com>
 <c8924b83-dfa2-a44c-a425-deb7e03d0bf1@talpey.com>
 <MWHPR2101MB0729D25131DCC9AF638E0449CEB40@MWHPR2101MB0729.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Long Li <longli@microsoft.com>, Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR2101MB0729D25131DCC9AF638E0449CEB40@MWHPR2101MB0729.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 4/20/2018 2:41 PM, Long Li wrote:
>> Subject: Re: [Patch v4] cifs: Allocate validate negotiation request through
>> kmalloc
>>
>> Looks good, but I have two possibly style-related comments.
>>
>> On 4/19/2018 5:38 PM, Long Li wrote:
>>> From: Long Li <longli@microsoft.com>
>>>
>>> The data buffer allocated on the stack can't be DMA'ed,
>>> ib_dma_map_page will return an invalid DMA address for a buffer on
>>> stack. Even worse, this incorrect address can't be detected by
>>> ib_dma_mapping_error. Sending data from this address to hardware will
>>> not fail, but the remote peer will get junk data.
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
>>> Changed several sizeof() to use *pointer in place of struct.
>>>
>>> Changes in v4:
>>> Added detailed comments on the failure through RDMA.
>>> Allocate request buffer using GPF_NOFS.
>>> Fixed possible memory leak.
>>>
>>> Fixes: ff1c038addc4 ("Check SMB3 dialects against downgrade attacks")
>>> Signed-off-by: Long Li <longli@microsoft.com>
>>> ---
>>>    fs/cifs/smb2pdu.c | 61 ++++++++++++++++++++++++++++++--------------
>> -----------
>>>    1 file changed, 33 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c index
>>> 0f044c4..caa2a1e 100644
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
>>
>> Seems awkward to have "rc" and "ret", and based on the code below I don't
>> see why two variables are needed. Simplify? (see later comment)
> 
> This is for addressing a prior comment to reduce duplicate code. All the failure paths
> (after issuing I/O) returning -EIO, there are 5 of them. Set rc to -EIO at the beginning
> so we don’t need to set it multiple times.

Well, ok but now there are semi-duplicate and rather confusing "rc"
and "ret" local variables, only one of which is actually returned.

How about a "goto err" with unconditonal -EIO, and just leave the
"return 0" path alone, like it was? That would be much clearer IMO.

As-is, I needed to read it several times to convince myself the right
rc was returned.

Tom,


> 
>>
>>> +	struct validate_negotiate_info_req *pneg_inbuf;
>>>    	struct validate_negotiate_info_rsp *pneg_rsp = NULL;
>>>    	u32 rsplen;
>>>    	u32 inbuflen; /* max of 4 dialects */ @@ -741,7 +741,6 @@ int
>>> smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>>>    	if (tcon->ses->server->rdma)
>>>    		return 0;
>>>    #endif
>>> -
>>>    	/* In SMB3.11 preauth integrity supersedes validate negotiate */
>>>    	if (tcon->ses->server->dialect == SMB311_PROT_ID)
>>>    		return 0;
>>> @@ -764,63 +763,67 @@ int smb3_validate_negotiate(const unsigned int
>> xid, struct cifs_tcon *tcon)
>>>    	if (tcon->ses->session_flags & SMB2_SESSION_FLAG_IS_NULL)
>>>    		cifs_dbg(VFS, "Unexpected null user (anonymous) auth flag
>> sent by
>>> server\n");
>>>
>>> -	vneg_inbuf.Capabilities =
>>> +	pneg_inbuf = kmalloc(sizeof(*pneg_inbuf), GFP_NOFS);
>>> +	if (!pneg_inbuf)
>>> +		return -ENOMEM;
>>> +
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
>>
>> The "- 2" is a little confusing here. This was existing code, but I suggest you
>> change this to a sizeof (u16) construct for consistency.
>> It's reducing by the length of a single Dialects[n] entry.
>>
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
>>
>> Ditto previous sizeof (u16) comment, with a *2 this case.
>>
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
>>
>> Why not leave "rc" alone, and set its value to -EIO before the goto if the ioctl
>> fails? That will simplify and make the code much more readable IMO.
>>
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
>>
>> Would need an rc = -EIO here too if above comment is accepted.
>>
>> Tom.
>>
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
