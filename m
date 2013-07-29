From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [PATCH 2/2] cifs: Correct comment about domainname length
Date: Sun, 28 Jul 2013 17:36:56 -0700
Message-ID: <CACyXjPxffbb8VQ55mCWTCP-GDivijXVkHNwtkVTwgAmi1XMyQQ@mail.gmail.com>
References: <1374777285-25639-1-git-send-email-scott.lovenberg@gmail.com>
	<1374777285-25639-2-git-send-email-scott.lovenberg@gmail.com>
	<51F1C564.5070006@asianux.com>
	<CAFB9KM2zF9m4Y4vcDRkZpMfvWP8NQWYKQTeJTiwgVVVu=4M6Cw@mail.gmail.com>
	<51F5B708.4090404@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: quoted-printable
Cc: "sfrench@samba.org" <sfrench@samba.org>,
	linux-cifs <linux-cifs@vger.kernel.org>, samba-technical@lists.samba.org,
	Jeff Layton <jlayton@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <51F5B708.4090404@asianux.com>
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

On Sun, Jul 28, 2013 at 5:27 PM, Chen Gang <gang.chen@asianux.com> wrote:
> On 07/27/2013 02:12 AM, Scott Lovenberg wrote:
>> On Thu, Jul 25, 2013 at 8:40 PM, Chen Gang <gang.chen@asianux.com> wrote=
:
>>> On 07/26/2013 02:34 AM, scott.lovenberg@gmail.com wrote:
>>>> From: Scott Lovenberg <scott.lovenberg@gmail.com>
>>>>
>>>> CIFS_MAX_DOMAINNAME_LEN is the max length for a domain name, not a ful=
ly qualified domain name.
>>>>
>>>> Signed-off-by: Scott Lovenberg <scott.lovenberg@gmail.com>
>>>> ---
>>>>  include/uapi/linux/cifs/cifs_mount.h | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/uapi/linux/cifs/cifs_mount.h b/include/uapi/linux=
/cifs/cifs_mount.h
>>>> index a58fc6e..d2408ec 100644
>>>> --- a/include/uapi/linux/cifs/cifs_mount.h
>>>> +++ b/include/uapi/linux/cifs/cifs_mount.h
>>>> @@ -17,7 +17,7 @@
>>>>  #define _CIFS_MOUNT_H
>>>>
>>>>  /* Max string lengths for cifs mounting options. */
>>>> -#define CIFS_MAX_DOMAINNAME_LEN 256 /* max fully qualified domain nam=
e */
>>>> +#define CIFS_MAX_DOMAINNAME_LEN 256 /* max domain name length */
>>>>  #define CIFS_MAX_USERNAME_LEN   256 /* reasonable max for current ser=
vers */
>>>>  #define CIFS_MAX_PASSWORD_LEN   512 /* Windows max seems to be 256 wi=
de chars */
>>>>  #define CIFS_MAX_SHARE_LEN      256 /* reasonable max share name leng=
th */
>>>>
>>>
>>> For our kernel implementation:
>>>
>>>   for 'CIFS_MAX_DOMAINNAME_LEN', it counts 255 + '\0',
>>>   for 'CIFS_MAX_USERNAME_LEN', it counts 256 (may add additional '\0'),
>>>
>>> And original mail said about 'CIFS_MAX_DOMAINNAME_LEN':
>>>
>>>   "The maximum length of ... the fully qualified domain name (FQDN) is
>>>   63 octets per label and 255 bytes per FQDN. This maximum includes 254
>>>   bytes for the FQDN and one byte for the ending dot."
>>>
>>> And excuse me, I do not know what 'CIFS_MAX_USERNAME_LEN' should be.
>>>
>>> Do we also need consider about it in our definition comments ?
>>>
>>>
>>> Thanks.
>>> --
>>> Chen Gang
>>
>> Sorry, I misunderstood; I figured that it had to be the domain name
>> without the host since we were allowing a host name that's 1024
>> characters long.  That documentation should probably be added to the
>> cifs_mount.h as well then.
>>
>> Still, how can we have a FQDN that's 256 characters long when the host
>> name length can be 1024 characters long?
>>
>
> Excuse me, I am not quite familiar about cifs, so can not provide
> additional more information (I found it only by reading code).
>
> But I feel, it really need additional discussion and check by the
> related experts (related members who are familiar with cifs).
>
> Welcome any members' suggestions and completions.
>
> Thanks.

Come on guys, enough already. As per here:
https://en.wikipedia.org/wiki/Domain_Name_System

and a comment above the max len of the fully qualified domain name (FQDN) i=
s
63 octets per label and 255 bytes per FQDN. This maximum includes 254
bytes for the FQDN and one byte for the ending dot.

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
