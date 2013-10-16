From: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>
Subject: Re: [PATCH 2/2 linux-next] cifs: Make big endian multiplex ID sequences
 monotonic on the wire
Date: Wed, 16 Oct 2013 09:02:49 -0700
Message-ID: <525EB8A9.1040802@tpi.com>
References: <1381936190-67628-1-git-send-email-timg@tpi.com>	<1381936190-67628-2-git-send-email-timg@tpi.com> <20131016114007.3b7d4fc6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131016114007.3b7d4fc6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/16/2013 08:40 AM, Jeff Layton wrote:
> On Wed, 16 Oct 2013 09:09:50 -0600
> Tim Gardner <timg-l6nL5VImRDY@public.gmane.org> wrote:
> 
>> The multiplex identifier (MID) in the SMB header is only
>> ever used by the client, in conjunction with PID, to match responses
>> from the server. As such, the endianess of the MID is not important.
>> However, When tracing packet sequences on the wire, protocol analyzers
>> such as wireshark display MID as little endian. It is much more informative
>> for the on-the-wire MID sequences to match debug information emitted by the
>> CIFS driver.  Therefore, one should write and read MID in the SMB header
>> assuming it is always little endian.
>>
>> Observed from wireshark during the protocol negotiation
>> and session setup:
>>
>>         Multiplex ID: 256
>>         Multiplex ID: 256
>>         Multiplex ID: 512
>>         Multiplex ID: 512
>>         Multiplex ID: 768
>>         Multiplex ID: 768
>>
>> After this patch on-the-wire MID values begin at 1 and increase monotonically.
>>
>> Introduce get_next_mid64() for the internal consumers that use the full 64 bit
>> multiplex identifier.
>>
>> Introduce the helpers get_mid() and compare_mid() to make the endian
>> translation clear.
>>
>> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> Signed-off-by: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>
>> ---
>>
>> I'm looking at some of this code in excrutiating detail because I'm having trouble
>> with a backport of CIFS from 3.9.7 on an embedded 2.6.31 powerpc. Its failing the RawNTLMSSP
>> authentication and is almost certainly an endian issue. x86 on the same code base works
>> quite well. Am I making a rash assumption that CIFS in 3.9 stable worked on big endian ?
>>
>>  fs/cifs/cifsglob.h      |   25 ++++++++++++++++++++++++-
>>  fs/cifs/misc.c          |    9 +++++----
>>  fs/cifs/smb1ops.c       |    4 ++--
>>  fs/cifs/smb2transport.c |    2 +-
>>  fs/cifs/transport.c     |    2 +-
>>  5 files changed, 33 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 52b6f6c..535e324 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -620,11 +620,34 @@ set_credits(struct TCP_Server_Info *server, const int val)
>>  }
>>  
>>  static inline __u64
>> -get_next_mid(struct TCP_Server_Info *server)
>> +get_next_mid64(struct TCP_Server_Info *server)
>>  {
>>  	return server->ops->get_next_mid(server);
>>  }
>>  
>> +static inline __u16
>> +get_next_mid(struct TCP_Server_Info *server)
>> +{
>> +	__u16 mid = get_next_mid64(server);
>> +	/*
>> +	 * The value in the SMB header should be little endian for easy
>> +	 * on-the-wire decoding.
>> +	 */
>> +	return cpu_to_le16(mid);
>> +}
>> +
>> +static inline __u16
>> +get_mid(const struct smb_hdr *smb)
>> +{
>> +	return le16_to_cpu(smb->Mid);
>> +}
>> +
>> +static inline bool
>> +compare_mid(__u16 mid, const struct smb_hdr *smb)
>> +{
>> +	return mid == le16_to_cpu(smb->Mid);
>> +}
>> +
>>  /*
>>   * When the server supports very large reads and writes via POSIX extensions,
>>   * we can allow up to 2^24-1, minus the size of a READ/WRITE_AND_X header, not
>> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
>> index 298e31e..c851d41 100644
>> --- a/fs/cifs/misc.c
>> +++ b/fs/cifs/misc.c
>> @@ -295,7 +295,8 @@ check_smb_hdr(struct smb_hdr *smb)
>>  	if (smb->Command == SMB_COM_LOCKING_ANDX)
>>  		return 0;
>>  
>> -	cifs_dbg(VFS, "Server sent request, not response. mid=%u\n", smb->Mid);
>> +	cifs_dbg(VFS, "Server sent request, not response. mid=%u\n",
>> +		 le16_to_cpu(smb->Mid));
>>  	return 1;
>>  }
>>  
>> @@ -358,11 +359,11 @@ checkSMB(char *buf, unsigned int total_read)
>>  				return 0; /* bcc wrapped */
>>  		}
>>  		cifs_dbg(FYI, "Calculated size %u vs length %u mismatch for mid=%u\n",
>> -			 clc_len, 4 + rfclen, smb->Mid);
>> +			 clc_len, 4 + rfclen, le16_to_cpu(smb->Mid));
>>  
>>  		if (4 + rfclen < clc_len) {
>>  			cifs_dbg(VFS, "RFC1001 size %u smaller than SMB for mid=%u\n",
>> -				 rfclen, smb->Mid);
>> +				 rfclen, le16_to_cpu(smb->Mid));
>>  			return -EIO;
>>  		} else if (rfclen > clc_len + 512) {
>>  			/*
>> @@ -375,7 +376,7 @@ checkSMB(char *buf, unsigned int total_read)
>>  			 * data to 512 bytes.
>>  			 */
>>  			cifs_dbg(VFS, "RFC1001 size %u more than 512 bytes larger than SMB for mid=%u\n",
>> -				 rfclen, smb->Mid);
>> +				 rfclen, le16_to_cpu(smb->Mid));
>>  			return -EIO;
>>  		}
>>  	}
> 
> It would be more efficient to byte-swap smb->Mid only once and store
> that in a u16 here and then print that out instead of doing it multiple
> times.
> 

OK, I'll send out V2.
-- 
Tim Gardner timg-l6nL5VImRDY@public.gmane.org www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
