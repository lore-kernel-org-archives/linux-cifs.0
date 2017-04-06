From: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] CIFS: queue 'reconnect' thread with a delay
Date: Thu, 6 Apr 2017 15:03:05 +0100
Message-ID: <2487ae35-2cd3-9227-b7eb-0b410ee6f980@citrix.com>
References: <1490743614-5439-2-git-send-email-germano.percossi@citrix.com>
 <1491415622.18814.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491415622.18814.6.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Some servers (Microsoft for example) reply to reconnection
requests with errors during the failover phase.
Asking repeatedly to reconnect (hundreds times in few
seconds) is not gonna solve the problem.

This is would happen (reconnection bugs aside, fix later)
without self-rescheduling and delay:
* one node fails over during I/O
* reconnect thread is immediately started
* server is not ready and send an error
* reconnect fails and exit
* echo will notice connection is down and schedule reconnect
* reconnect (hopefully succeeds)

The problem here is that the echo timeout will make the difference:
60 seconds for some applications are not tolerable and
making echo more frequent just to solve a once-off problem is
sub-optimal.

The reason for rescheduling by itself is to avoid relying
on the echo thread and make possible to tune parameters
separately: echo can still be used with its default (60s)
without impacting the reconnect that usually happens when
there is pending I/O.

My initial idea was to make it configurable like
echo_interval.
Happy to do it if the whole idea of a delay and self rescheduling
is accepted.

Cheers,
Germano

P.S: there is a coding style error in this patch, I am
sending the correct version.

On 04/05/2017 07:07 PM, Sachin Prabhu wrote:
> On Wed, 2017-03-29 at 00:26 +0100, Germano Percossi wrote:
>> All the other threads are queue with a delay, no reason
>> why this one need to be so aggressive.
> 
> Is there any reason to queue with a delay? Is there a problem with
> reconnecting immediately?
> 
> Sachin Prabhu
> 
>>
>> Signed-off-by: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/smb2pdu.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index 7446496..efe167c 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -258,7 +258,7 @@ smb2_reconnect(__le16 smb2_command, struct
>> cifs_tcon *tcon)
>>  		goto out;
>>  
>>  	if (smb2_command != SMB2_INTERNAL_CMD)
>> -		queue_delayed_work(cifsiod_wq, &server->reconnect,
>> 0);
>> +		queue_delayed_work(cifsiod_wq, &server->reconnect, 2
>> * HZ);
>>  
>>  	atomic_inc(&tconInfoReconnectCount);
>>  out:
>> @@ -2231,7 +2231,7 @@ SMB2_echo(struct TCP_Server_Info *server)
>>  
>>  	if (server->tcpStatus == CifsNeedNegotiate) {
>>  		/* No need to send echo on newly established
>> connections */
>> -		queue_delayed_work(cifsiod_wq, &server->reconnect,
>> 0);
>> +		queue_delayed_work(cifsiod_wq, &server->reconnect, 2
>> * HZ);
>>  		return rc;
>>  	}
>>  
> 
