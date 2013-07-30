From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH 2/2] cifs: Correct comment about domainname length
Date: Tue, 30 Jul 2013 08:31:09 +0800
Message-ID: <51F7094D.607@asianux.com>
References: <1374777285-25639-1-git-send-email-scott.lovenberg@gmail.com>
	<1374777285-25639-2-git-send-email-scott.lovenberg@gmail.com>
	<51F1C564.5070006@asianux.com>
	<CAFB9KM2zF9m4Y4vcDRkZpMfvWP8NQWYKQTeJTiwgVVVu=4M6Cw@mail.gmail.com>
	<51F5B708.4090404@asianux.com>
	<CACyXjPxffbb8VQ55mCWTCP-GDivijXVkHNwtkVTwgAmi1XMyQQ@mail.gmail.com>
	<20130729161709.19c52e0f@tlielax.poochiereds.net>
	<CAFB9KM3CxJcHdFPrGTW595hjNzvYnLgVA6F8J3EMdddz3n0ivw@mail.gmail.com>
	<51F70456.3050901@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "sfrench@samba.org" <sfrench@samba.org>,
	linux-cifs <linux-cifs@vger.kernel.org>, samba-technical@lists.samba.org,
	Jeff Layton <jlayton@redhat.com>
To: Scott Lovenberg <scott.lovenberg@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <51F70456.3050901@asianux.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On 07/30/2013 08:09 AM, Chen Gang wrote:
> On 07/30/2013 05:10 AM, Scott Lovenberg wrote:
>> On Mon, Jul 29, 2013 at 4:17 PM, Jeff Layton <jlayton@redhat.com> wrote:
>>>>>> Still, how can we have a FQDN that's 256 characters long when the host
>>>>>> name length can be 1024 characters long?
>>>>>>
>>>>>
>>>>> Excuse me, I am not quite familiar about cifs, so can not provide
>>>>> additional more information (I found it only by reading code).
>>>>>
>>>>> But I feel, it really need additional discussion and check by the
>>>>> related experts (related members who are familiar with cifs).
>>>>>
>>>>> Welcome any members' suggestions and completions.
>>>>>
>>>>> Thanks.
>>>>
>>>> Come on guys, enough already. As per here:
>>>> https://en.wikipedia.org/wiki/Domain_Name_System
>>>>
>>>> and a comment above the max len of the fully qualified domain name (FQDN) is
>>>> 63 octets per label and 255 bytes per FQDN. This maximum includes 254
>>>> bytes for the FQDN and one byte for the ending dot.
>>>>
>>>
>>> Ok, I think I knew that at one point and paged it out. It does make one
>>> wonder why NI_MAXHOST is so big though -- is that for some
>>> internationalization scheme?
>>>
>>> --
>>> Jeff Layton <jlayton@redhat.com>
>>
>> I guess it works if you're storing as UTF-32 or wchar_t at 4 bytes per
>> character. 256 characters * 4 bytes/char + 1 byte for NULL.  Microsoft
>> seems to use the same value for NI_MAXHOST ref:
>> http://msdn.microsoft.com/en-us/library/windows/desktop/ms738532(v=vs.85).aspx
>> .
>>
> 
> As far as I know, the kernel implementation wants to use 255 + 1 as
> character count, not bytes count for FQDN (256 bytes for 8-bit, 512
> bytes for 16-bit, ...), it can be translated into uni-code or other
> format within 255 + 1 character count.
> 
> May it be useful for our discussion ?
> 
> (BTW: if kernel really wants to do, I also suggest to check the kernel
> implementation for it whether correct or not).
> 
> 
> Thanks.
> 

OH, sorry, what I said above is incorrect. The kernel implementation use
255 + 1 as bytes, it can be translated into uni-code within 255 + 1
character count.

For NI_MAXHOST, I think we do not mind it: WIKI is more common than
Microsoft. and Microsoft also says: "To simplify determining buffer
requirements ..." (I guess, the "simplify determining" is
"sizeof(UTF-32) * 256 + '\0'").


:-)

Thanks.
-- 
Chen Gang
