From: Scott Lovenberg <scott.lovenberg@gmail.com>
Subject: Re: [PATCH] cifs: extend the buffer length enought for sprintf() using
Date: Thu, 18 Jul 2013 02:47:08 -0400
Message-ID: <CAFB9KM2MbLuETpoN9wafZLq6B9StjtXnG15G16uGcOcnRM8+sA@mail.gmail.com>
References: <51E5E9DA.8020603@asianux.com>
	<CAFB9KM2nJEt-O+o=4bkxNMJ2Fr0TfjkpRF=7B98=Lp9zFu8_og@mail.gmail.com>
	<CAH2r5msQEbQWpE+wqEoLY_++=ywDVoAg_vmWB3kJG8=ECHC3Pg@mail.gmail.com>
	<CAFB9KM0rEDyE6hb8t-gDLTDKq9kaRr4Bhs7SLBEZTnyH5u5U-A@mail.gmail.com>
	<51E74008.8050308@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "sfrench@samba.org" <sfrench@samba.org>, Steve French <smfrench@gmail.com>,
	samba-technical@lists.samba.org, Jeff Layton <jlayton@redhat.com>,
	linux-cifs <linux-cifs@vger.kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <51E74008.8050308@asianux.com>
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

On Wed, Jul 17, 2013 at 9:08 PM, Chen Gang <gang.chen@asianux.com> wrote:
> On 07/18/2013 02:27 AM, Scott Lovenberg wrote:
>> On Tue, Jul 16, 2013 at 10:06 PM, Steve French <smfrench@gmail.com> wrote:
>>
>>>> If this is correct for the domain size, MAX_DOMAIN_SIZE in the
>>>> cifs-utils mount helper (mount.cifs.c) has to be changed.  It is
>>>> currently 64 + null terminator.  I can open a bug and patch it if this
>>>> is correct.
>>>>
>>>> CC'ing Jeff Layton since he maintains the cifs-utils package.
>>>>
>>>> --
>>>> Peace and Blessings,
>>>> -Scott.
>>>
>>> http://support.microsoft.com/kb/909264 indicates that (at least for
>>> Microsoft) domain names can be considerably longer than 64 bytes, so
>>> this patch seems reasonable.  Merged into cifs-2.6.git - if anyone
>>> objects or wants to add ack/reviewed let me know.
>>>
>>>
>>> "The maximum length of ... the fully qualified domain name (FQDN) is
>>> 63 octets per label and 255 bytes per FQDN. This maximum includes 254
>>> bytes for the FQDN and one byte for the ending dot."
>>>
>>>
>>> --
>>> Thanks,
>>>
>>> Steve
>>
>> Thanks, Steve.  I'll patch this tonight.
>>
>
> Firstly, thank you for your work.
>
> Hmm... could you please wait for 1-2 days so can let this patch given
> more checking by another contributors ?
>
> If possible, after finish discussing, I should/will send patch v2 for it.
>
> Is it OK ?
>
>
> Thanks.
> --
> Chen Gang

Thank you for your work. :)
That's completely reasonable.  I'll submit in a day or two.

--
Peace and Blessings,
-Scott.
