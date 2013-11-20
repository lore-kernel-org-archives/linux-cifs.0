From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2][CIFS] Validate Negotiate Info
Date: Tue, 19 Nov 2013 23:55:12 -0600
Message-ID: <CAH2r5mvYj0=ifOyhsb950bzVHWjxRn+AC6jZV9+p55w+7q6wZA@mail.gmail.com>
References: <CAH2r5mufCuB6b1aLbezcdPW8uAsFs7ojoW-L3E5MhrouEb9kVQ@mail.gmail.com>
	<CAKywueSdjH-AWsy4JhssF8+3aHFNYnyOnRkAG0DiWwcrHh4oUw@mail.gmail.com>
	<CAH2r5msn_SR1vfko+Fwy5zexfuaiQoPwsf2+swJCjSPvM+pdfQ@mail.gmail.com>
	<CAH2r5mvZJL6Z6zykLC3HcgHtxd=T6b15q4GoO1QRDjCZs8Q=8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvZJL6Z6zykLC3HcgHtxd=T6b15q4GoO1QRDjCZs8Q=8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Minor change to not log error message

http://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=ff1c038addc4f205d5f1ede449426c7d316c0eed

On Tue, Nov 19, 2013 at 11:50 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Updated patch with the minor change you suggested is now in
> cifs-2.6.git for-next
>
> http://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=6f3219c1bc3b0f33a513ba63cea8278f1cd89ab3
>
> On Tue, Nov 19, 2013 at 11:34 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Tue, Nov 19, 2013 at 11:33 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> 2013/11/19 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>>> From e4608aa57f9948a5e160ecb8590c885f76796e34 Mon Sep 17 00:00:00 2001
>>>> From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>> Date: Tue, 19 Nov 2013 12:58:08 -0600
>>>> Subject: [PATCH] [CIFS] Check SMB3 dialects against downgrade attacks
>>>>
>>>> When we are running SMB3 or SMB3.02 connections which are signed
>>>> we need to validate the protocol negotiation information,
>>>> to ensure that thenegotiate protocol response was not tampered with.
>>>>
>>>> Add the missing FSCTL which is sent at mount time (immediately after
>>>> the SMB3 Tree Connect) to validate that the capabilities match
>>>> what we think the server sent.
>>>>
>>>> "Secure dialect negotiation is introduced in SMB3 to protect against
>>>> man-in-the-middle attempt to downgrade dialect negotiation.
>>>> The idea is to prevent an eavesdropper from downgrading the initially
>>>> negotiated dialect and capabilities between the client and the server."
>>>>
>>>> For more explanation see 2.2.31.4 of MS-SMB2 or
>>>> http://blogs.msdn.com/b/openspecification/archive/2012/06/28/smb3-secure-dialect-negotiation.aspx
>>>>
>>>> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>> ---
>>>>  fs/cifs/cifsglob.h  |  1 +
>>>>  fs/cifs/smb2ops.c   |  1 +
>>>>  fs/cifs/smb2pdu.c   | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  fs/cifs/smb2pdu.h   | 12 ++++++---
>>>>  fs/cifs/smb2proto.h |  1 +
>>>>  fs/cifs/smbfsctl.h  |  2 +-
>>>>  6 files changed, 89 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>>>> index d9ea7ad..f918a99 100644
>>>> --- a/fs/cifs/cifsglob.h
>>>> +++ b/fs/cifs/cifsglob.h
>>>> @@ -384,6 +384,7 @@ struct smb_version_operations {
>>>>   int (*clone_range)(const unsigned int, struct cifsFileInfo *src_file,
>>>>   struct cifsFileInfo *target_file, u64 src_off, u64 len,
>>>>   u64 dest_off);
>>>> + int (*validate_negotiate)(const unsigned int, struct cifs_tcon *);
>>>>  };
>>>>
>>>>  struct smb_version_values {
>>>> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>>>> index a3968ee..757da3e 100644
>>>> --- a/fs/cifs/smb2ops.c
>>>> +++ b/fs/cifs/smb2ops.c
>>>> @@ -1319,6 +1319,7 @@ struct smb_version_operations smb30_operations = {
>>>>   .create_lease_buf = smb3_create_lease_buf,
>>>>   .parse_lease_buf = smb3_parse_lease_buf,
>>>>   .clone_range = smb2_clone_range,
>>>> + .validate_negotiate = smb3_validate_negotiate,
>>>>  };
>>>>
>>>>  struct smb_version_values smb20_values = {
>>>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>>>> index 1e136ee..7756f9b 100644
>>>> --- a/fs/cifs/smb2pdu.c
>>>> +++ b/fs/cifs/smb2pdu.c
>>>> @@ -454,6 +454,80 @@ neg_exit:
>>>>   return rc;
>>>>  }
>>>>
>>>> +int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>>>> +{
>>>> + int rc = 0;
>>>> + struct validate_negotiate_info_req vneg_inbuf;
>>>> + struct validate_negotiate_info_rsp *pneg_rsp;
>>>> + u32 rsplen;
>>>> +
>>>> + cifs_dbg(VFS, "validate negotiate ");
>>>> + vneg_inbuf.Capabilities =
>>>> + cpu_to_le32(tcon->ses->server->vals->req_capabilities);
>>>> + memcpy(vneg_inbuf.Guid, cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
>>>> +
>>>> + /*
>>>> + * validation ioctl must be signed, so no point sending this if we
>>>> + * can not sign it.  We could eventually change this to selectively
>>>> + * sign just this, the first and only signed request on a connection.
>>>> + * This is good enough for now since a user who wants better security
>>>> + * would also enable signing on the mount. Having validation of
>>>> + * negotiate info for signed connections helps reduce attack vectors
>>>> + */
>>>> + if (tcon->ses->server->sign == false)
>>>> + return 0; /* validation requires signing */
>>>
>>> Shouldn't we move the above check and comments before we set
>>> Capabilities and Guid of vneg_inbuf?
>>
>> Yes - will do
>>
>>
>> --
>> Thanks,
>>
>> Steve
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
