From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: trivial: cleanup fscache cFYI and cERROR messages
Date: Mon, 20 Jun 2011 11:28:21 +0530
Message-ID: <4DFEE17D.50000@suse.de>
References: <4DF7804B.8000502@suse.de>	<20110614120048.7c04567d@corrin.poochiereds.net>	<4DF87E1D.70802@suse.de>	<20110615085841.633bb3c3@corrin.poochiereds.net>	<4DF8AEC5.5030703@suse.de> <BANLkTim-T4PKGfsX-XQT5mP1EwLLkDMDwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTim-T4PKGfsX-XQT5mP1EwLLkDMDwg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/15/2011 08:12 PM, Steve French wrote:
> 
> The idea of the 1st parameter to cerror was to allow turning off log
> spam more easily if error turned out to be expected.  Gave some
> flexibility debugging too.

Ok, but still it doesn't allow us to turn off logs in the runtime (have
to be recompiled, right?). OTOH, wouldn't be easier to convert a cERROR
to cFYI in case if we found if the error is expected or use cifswarn()
instead?


> On Jun 15, 2011 8:08 AM, "Suresh Jayaraman" <sjayaraman-l3A5Bk7waGM@public.gmane.org
> <mailto:sjayaraman-l3A5Bk7waGM@public.gmane.org>> wrote:
>> On 06/15/2011 06:28 PM, Jeff Layton wrote:
>>> On Wed, 15 Jun 2011 15:10:45 +0530
>>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org <mailto:sjayaraman-l3A5Bk7waGM@public.gmane.org>> wrote:
>>>
>>>> On 06/14/2011 09:30 PM, Jeff Layton wrote:
>>>>> On Tue, 14 Jun 2011 21:07:47 +0530
>>>>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org <mailto:sjayaraman-l3A5Bk7waGM@public.gmane.org>>
> wrote:
>>>>>
>>>>>> ... for uniformity and cleaner debug logs.
>>>>>>
>>>>>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org
> <mailto:sjayaraman-l3A5Bk7waGM@public.gmane.org>>
>>>>>> ---
>>>>>> fs/cifs/cache.c | 6 +++---
>>>>>> fs/cifs/fscache.c | 53
> +++++++++++++++++++++++++----------------------------
>>>>>> 2 files changed, 28 insertions(+), 31 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
>>>>>> index dd8584d..545509c 100644
>>>>>> --- a/fs/cifs/cache.c
>>>>>> +++ b/fs/cifs/cache.c
>>>>>> @@ -92,7 +92,7 @@ static uint16_t cifs_server_get_key(const void
> *cookie_netfs_data,
>>>>>> break;
>>>>>>
>>>>>> default:
>>>>>> - cERROR(1, "CIFS: Unknown network family '%d'", sa->sa_family);
>>>>>> + cERROR(1, "Unknown network family '%d'", sa->sa_family);
>>>>> ^^^^^^^^^
>>>>> Maybe this would be a good time to add in a new
>>>>> cFYI/cERROR "flag" for fscache and convert all of these
>>>>> to use it?
>>>>
>>>> Sounds like a good idea to flag fsc debug messages separately but
>>>> flagging errors separately would be useful?
>>>>
>>>


-- 
Suresh Jayaraman
