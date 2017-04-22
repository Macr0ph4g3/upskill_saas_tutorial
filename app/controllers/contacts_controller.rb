class ContactsController < ApplicationController
  # Get request to /contact-us
  # Show new contact form
  def new
    @contact = Contact.new
  end
  
  
  #POST request /contacts
  def create
    #Mass assignment of formfields into Contact object
    @contact = Contact.new(contact_params)
    #Save the Contact object to the database
    if @contact.save
      #Store formfields via parameters, into local variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body =  params[:contact][:comments]
      #plug variables into the contact mailer email method and send email
      ContactMailer.contact_email(name, email, body).deliver
      #Store success message in flash hash
      #And redirect to new action
      flash[:success] = "Message Sent"
      redirect_to new_contact_path
    else
      #If Contact object doesn't save
      #Store errors in flash hash
      #And redirect into new path anyway
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end
  
  private
  #To collect data in form, we need to use strong parameters.
  #Strong parameters and whitelist form fields
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end