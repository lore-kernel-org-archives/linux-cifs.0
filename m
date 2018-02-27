From: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Subject: Re: [PATCH 4.13 28/43] SMB3: Validate negotiate request must always
 be signed
Date: Mon, 26 Feb 2018 19:44:28 -0800
Message-ID: <28ffc363-5140-5685-d288-6e3dc07c6369@csail.mit.edu>
References: <20171031095530.520746935@linuxfoundation.org>
 <20171031095531.633196173@linuxfoundation.org>
 <97340c9a-0ea2-0d3d-cf26-58c799d76cae@mageia.org>
 <20171101151803.GB31285@kroah.com>
 <4ba67095-4075-688f-d3fb-157847aee4d9@csail.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        lsahlber@redhat.com, pshilov@microsoft.com,
        linux-cifs@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Backlund <tmb@mageia.org>,
        Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <4ba67095-4075-688f-d3fb-157847aee4d9@csail.mit.edu>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 1/3/18 6:15 PM, Srivatsa S. Bhat wrote:
> On 11/1/17 8:18 AM, Greg Kroah-Hartman wrote:
>> On Tue, Oct 31, 2017 at 03:02:11PM +0200, Thomas Backlund wrote:
>>> Den 31.10.2017 kl. 11:55, skrev Greg Kroah-Hartman:
>>>> 4.13-stable review patch.  If anyone has any objections, please let me know.
>>>>
>>>> ------------------
>>>>
>>>> From: Steve French <smfrench@gmail.com>
>>>>
>>>> commit 4587eee04e2ac7ac3ac9fa2bc164fb6e548f99cd upstream.
>>>>
>>>> According to MS-SMB2 3.2.55 validate_negotiate request must
>>>> always be signed. Some Windows can fail the request if you send it unsigned
>>>>
>>>> See kernel bugzilla bug 197311
>>>>
>>>> Acked-by: Ronnie Sahlberg <lsahlber.redhat.com>
>>>> Signed-off-by: Steve French <smfrench@gmail.com>
>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>
>>>> ---
>>>>   fs/cifs/smb2pdu.c |    3 +++
>>>>   1 file changed, 3 insertions(+)
>>>>
>>>> --- a/fs/cifs/smb2pdu.c
>>>> +++ b/fs/cifs/smb2pdu.c
>>>> @@ -1963,6 +1963,9 @@ SMB2_ioctl(const unsigned int xid, struc
>>>>   	} else
>>>>   		iov[0].iov_len = get_rfc1002_length(req) + 4;
>>>> +	/* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
>>>> +	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
>>>> +		req->hdr.sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
>>>>   	rc = SendReceive2(xid, ses, iov, n_iov, &resp_buftype, flags, &rsp_iov);
>>>>   	cifs_small_buf_release(req);
>>>>
>>>>
>>>>
>>>
>>> This one needs to be backported to all stable kernels as the commit that
>>> introduced the regression:
>>> '
>>> 0603c96f3af50e2f9299fa410c224ab1d465e0f9
>>> SMB: Validate negotiate (to protect against downgrade) even if signing off
>>>
>>> is backported in stable trees as of: 4.9.53, 4.4.90, 3.18.73
>>
>> Oh wait, it breaks the builds on older kernels, that's why I didn't
>> apply it :)
>>
>> Can you provide me with a working backport?
>>
> 
> Hi Steve,
> 
> Is there a version of this fix available for stable kernels?
> 

Hi Greg,

Mounting SMB3 shares continues to fail for me on 4.4.118 and 4.9.84
due to the issues that I have described in detail on this mail thread.

Since there is no apparent fix for this bug on stable kernels, could
you please consider reverting the original commit that caused this
regression?

That commit was intended to enhance security, which is probably why it
was backported to stable kernels in the first place; but instead it
ends up breaking basic functionality itself (mounting). So in the
absence of a proper fix, I don't see much of an option but to revert
that commit.

So, please consider reverting the following:

commit 02ef29f9cbb616bf419 "SMB: Validate negotiate (to protect
against downgrade) even if signing off" on 4.4.118

commit 0e1b85a41a25ac888fb "SMB: Validate negotiate (to protect
against downgrade) even if signing off" on 4.9.84

They correspond to commit 0603c96f3af50e2f9299fa410c224ab1d465e0f9
upstream. Both these patches should revert cleanly. 

Thank you!

Regards,
Srivatsa
