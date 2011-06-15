From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: trivial: cleanup fscache cFYI and cERROR messages
Date: Wed, 15 Jun 2011 15:10:45 +0530
Message-ID: <4DF87E1D.70802@suse.de>
References: <4DF7804B.8000502@suse.de> <20110614120048.7c04567d@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110614120048.7c04567d-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/14/2011 09:30 PM, Jeff Layton wrote:
> On Tue, 14 Jun 2011 21:07:47 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
>> ... for uniformity and cleaner debug logs.
>>
>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> ---
>>  fs/cifs/cache.c   |    6 +++---
>>  fs/cifs/fscache.c |   53 +++++++++++++++++++++++++----------------------------
>>  2 files changed, 28 insertions(+), 31 deletions(-)
>>
>> diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
>> index dd8584d..545509c 100644
>> --- a/fs/cifs/cache.c
>> +++ b/fs/cifs/cache.c
>> @@ -92,7 +92,7 @@ static uint16_t cifs_server_get_key(const void *cookie_netfs_data,
>>  		break;
>>  
>>  	default:
>> -		cERROR(1, "CIFS: Unknown network family '%d'", sa->sa_family);
>> +		cERROR(1, "Unknown network family '%d'", sa->sa_family);
> 			^^^^^^^^^
> 		Maybe this would be a good time to add in a new
> 		cFYI/cERROR "flag" for fscache and convert all of these
> 		to use it?

Sounds like a good idea to flag fsc debug messages separately but
flagging errors separately would be useful?

Also, I don't understand the idea behing the "set" currently.

we have

#define cFYI(set, fmt, arg...)                  \
do {                                            \
        if (set)                                \
                cifsfyi(fmt, ##arg);            \
} while (0)

and we call cFYI with always pass like this:
	cFYI(1, "..");



-- 
Suresh Jayaraman
