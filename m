From: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Fri, 09 Mar 2012 13:04:29 -0600
Message-ID: <4F5A543D.2040808@samba.org>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru> <1329895984-9251-7-git-send-email-piastry@etersoft.ru> <CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com> <CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw@mail.gmail.com> <20120303070921.5ce2bb10@tlielax.poochiereds.net> <CAH2r5mvGjzS73bhgG54Yzcqui9qxfv7e3yrxWZX+weSUQB4cHA@mail.gmail.com> <20120309073930.3a79fa10@redhat.com> <CAH2r5mvzgnTcyhL-Rip9yHUEMsLOCFhfAoNdRyVqhNFin_A6mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvzgnTcyhL-Rip9yHUEMsLOCFhfAoNdRyVqhNFin_A6mw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 03/09/2012 10:45 AM, Steve French wrote:
> On Fri, Mar 9, 2012 at 6:39 AM, Jeff Layton<jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>  wrote:
>> On Sat, 3 Mar 2012 21:14:19 -0600
>> Steve French<smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  wrote:
>>
>>>
>>> On the issue of why Samba didn't up maxmpx, I expect it is simply that
>>> until Jeff fixed async read/write, it was rare for a client to send 50
>>> requests in parallel.
>>>
>>
>> Are windows clients hard capped at 50 outstanding calls or so?
>
> No.   Windows can definitely go beyond 50.  And clients apparently do
> sometimes go
> beyond 50 )(even if server negotiates 50) as the following Microsoft
> TechNote implies:
>
> "Because the limit on outstanding requests is negotiated between the
> client and and server and is enforced by the client, this value might
> not be the actual maximum used. Increasing this value might improve
> server performance, but it requires more receive buffers (also known
> as work items ) on the server.  Note:  For Windows NT 4.0 Service Pack
> 3 and later, the valid values for this entry range from 1 to 65,535
> requests, with a default value of 50 requests. Windows 2000 limits the
> maximum value of this entry to 125 requests to assure that Windows 95
> and Windows 98 clients can connect to the server."

My memory is fuzzy, but I did research this when my team and I were writing 
the SMB/CIFS documentation.  What I recall is that Windows servers have a 
fixed pool of Receive Buffers (used to receive incoming messages).  When a 
message comes in, a Receive Buffer is allocated and the message is copied 
into the Receive Buffer.  The Receive Buffer is then placed into the pending 
message table for the connection.  (A connection is a single transport link 
between client and server.  There may be several SMB Sessions per connection.)

I do not know what happens if the pending message table fills up.  I 
*believe* that the server will stop reading messages from the connection, 
but this should be verified by checking with Microsoft and by testing.  It 
will be difficult to get conclusive results, since the server will be 
working to answer the outstanding requests and remove them from the table at 
the same time.

In any case, the protocol specifications define MaxMpxCount as a hard limit. 
  The client is simply not supposed to overfill the server's outstanding 
request table.  Unpredictable things will happen, particularly when you 
start running against other servers (Samba, EMC, NetApp, etc.) all of which 
will have implemented this differently.

One more note on this:  The ability to modify the size of the table was not 
used heavily in the early days and I suspect, based upon test results that 
Steve shared with me in Redmond, that there may be some bugs exposed in some 
servers if you increase the size of the table.  One errant hard-coded value 
is all it takes.  Proceed with caution.

> Apparently IIS and Windows Terminal Server (as a client to NAS boxes)
> need more than 50 - see this quote from NetApp server manual.
>
> "cifs.max_mpx
> This option controls how many simultaneous operations the filer
> reports that it can process.  An "operation" is each I/O the
> client believes is pending on the filer including outstanding
> change notify operations.  Clients such as Windows Terminal
> Server or IIS may require that this number be increased
> to avoid errors and performance delays."

Windows Terminal Server and IIS will likely have a lot of processes and 
threads talking to the server over the same connection at the same time--a 
lot of parallelism.

> Note that on the WIndows server side note that there is MaxMpxCt which
> controls it and a second parm maxworkitems which helps avoid hangs (as
> we found out in testing).

Search for MaxWorkItems in this doc:
   http://msdn.microsoft.com/en-us/library/cc615012.aspx

The description of MaxWorkItems is poorly written (by my standards) but it 
seems to indicate that MaxWorkItems controls the overall server pool of 
receive buffers.  MaxMpxCt, in contrast, refers to individual connections.

>>> On the SMB2 credits vs. CIFS maxmpx topic ...  more than once at the
>>> MS Plugfest I heard pushback on treating SMB2 credits and CIFS maxmpx
>>> similarly - they are totally unrelated.  SMB2 credits are pretty
>>> straightforward - we get them back on every request so they are
>>> constantly changing, but the rules are easier to understand (and are
>>> well documented, where the CIFS maxmpx behavior is only partially
>>> documented).

If there is missing documentation on the MaxMpxCount negotiation or the use 
of the value, it should be reported as a bug.

Please prove me wrong if I'm wrong, but I believe that the expected wire 
behavior is well covered in [MS-CIFS], and that references are given to 
other documentation to provide the deeper "what Windows does" documentation. 
  I wrote most of that stuff, so show me what's missing.  I found it all 
when I looked.

>> I can understand their POV, and that may be correct. I think we ought
>> to step back though and consider the fundamental problem that we're
>> trying to solve. When we want to send a call on the wire, we need to
>> know:
>>
>> "Is this particular call allowed to go out onto the wire at this time
>> or does it need to wait for another event to occur?"
>>
>> Earlier, I suggested: "Let's treat SMB1 maxmpx handling as a trivial
>> case of SMB2 credits." If that's not possible for some reason then we
>> ought to consider something like this:
>>
>> "Let's build this out the transport layer so that it can accomodate
>> both sets of protocols by allowing us to plug in different rules
>> depending on the protocol."

Hmmm...

>> Now that we're looking more closely at this, I think you're correct
>> that SMB1 maxmpx limits and SMB2 credits follow different "rules". But
>> I also think that it's best to engineer this in such a way that we can
>> "plug in" the correct ruleset for answering the above question based on
>> the protocol version in use.
 >>
>> The trick is to do this in such a way that we only "plug in" what needs
>> to be different. If treating SMB1 maxmpx limits as a trivial case of
>> SMB2 credits is too difficult, then I would take that as a sign that we
>> just need to expand how much of that decision making needs to be
>> protocol specific.

The folks at Microsoft (who are, of course, well ahead in their SMB2.x 
implementations) are very surprised that we are trying to maintain a single 
codebase for both protocols.  (I heard the same thing from several Microsoft 
engineers during separate conversations.)

My concern with this approach is that there are enough differences between 
the two protocols that we will wind up with more plug-ins than common code. 
  It'll look like hair transplant surgery gone very, very wrong.  I prefer 
to turn this around and think about what code can be conveniently used by 
both protocol stacks.

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh-zuGDro9SezXYtjvyW6yDsg@public.gmane.org
